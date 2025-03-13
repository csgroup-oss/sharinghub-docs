# Dataset with HuggingFace interface

## Introduction

In this tutorial you will learn how to create a `dataset.py` for defining a HuggingFace
`datasets` interface.

A dataset contains files, most likely divided in directories with a specific layout.
The Hugging Face's `datasets` library allows you to create and load custom datasets efficiently,
by offering a standardized Python API interface to interact with the data,
making it reusable and shareable.

This guide explains how to define a `dataset.py` file to create a dataset compatible
with `datasets.load_dataset()`.

## Prerequisites

Before proceeding, make sure you have `datasets` installed:

```bash
pip install datasets
```

## HuggingFace interface

### Structure

Your dataset will include the data itself and a dataset script named `dataset.py`.
This script defines how to download, load, and process data.

The Structure of a `dataset.py` consists of:

- Dataset configuration: class that defines configurations, inheriting from `datasets.BuilderConfig`.
- Dataset: The main dataset class, inheriting from `datasets.GeneratorBasedBuilder`.

### Example `dataset.py`

```python
import datasets

_DESCRIPTION = """A custom image dataset."""
_HOMEPAGE = "https://example.com"
_LICENSE = "MIT"
_CITATION = """@article{your_citation, title={Your Dataset} }"""

class CustomDatasetConfig(datasets.BuilderConfig):
    def __init__(self, **kwargs):
        super(CustomDatasetConfig, self).__init__(**kwargs)

class CustomDataset(datasets.GeneratorBasedBuilder):
    BUILDER_CONFIGS = [
        CustomDatasetConfig(name="default", version=datasets.Version("1.0.0"), description="Default config")
    ]

    def _info(self):
        """Defines the dataset's schema, including features (columns) and metadata."""
        return datasets.DatasetInfo(
            description=_DESCRIPTION,
            features=datasets.Features({
                "image": datasets.Image(),
                "label": datasets.ClassLabel(names=["cat", "dog"]),
            }),
            supervised_keys=("image", "label"),
            homepage=_HOMEPAGE,
            citation=_CITATION,
        )

    def _split_generators(self, dl_manager):
        """Splits the dataset into predefined subsets (for example, train, validation, test)."""
        data_dir = "path/to/your/data"
        return [
            datasets.SplitGenerator(name=datasets.Split.TRAIN, gen_kwargs={"data_dir": data_dir}),
        ]

    def _generate_examples(self, data_dir):
        """Iterates over the dataset files and yields data samples in a structured format."""
        import os
        for i, filename in enumerate(os.listdir(data_dir)):
            label = "cat" if "cat" in filename else "dog"
            yield i, {"image": os.path.join(data_dir, filename), "label": label}
```

### Usage

The `datasets.load_dataset()` function interacts with `dataset.py` through a series of method
calls that define how data is loaded, processed, and structured. Here’s a step-by-step breakdown:

1. **Detecting the Dataset Script:**
    - When calling `load_dataset("path/to/dataset.py")`, the `datasets` library identifies and
      imports the `CustomDataset` class defined in `dataset.py`.

2. **Calling `_info()`:**
    - The `_info()` method provides metadata about the dataset, including:
       - **Features:** Defines the dataset structure (for example, images and labels).
       - **Supervised Keys:** Specifies input-output pairs for supervised learning.
       - **Dataset Citation & Homepage:** Provides dataset references.

3. **Calling `_split_generators()`:**
    - This method is responsible for splitting the dataset into predefined subsets
      (for example, `train`, `validation`, `test`).
    - The `dl_manager` argument can be used to download and extract files if needed.
    - Each split is returned as a `datasets.SplitGenerator`, which provides parameters
      to `_generate_examples()`.

4. **Calling `_generate_examples()`:**
    - This method iterates over the dataset files and yields structured examples.
    - The function returns data in a format that matches the schema defined in `_info()`.
    - Example:

      ```python
      yield i, {"image": os.path.join(data_dir, filename), "label": label}
      ```

    - Each yielded sample becomes an entry in the final dataset.

5. **Using Streaming Mode:**
    - If the dataset is large and does not fit in memory, `datasets.load_dataset()` can be used to enable streaming mode:

      ```python
      dataset = datasets.load_dataset("path/to/dataset.py", split="train", streaming=True)
      ```

    - When streaming is enabled, `_generate_examples()` is called. Samples are fetched and processed on demand rather than all at once.
    - This is useful for large datasets stored remotely (e.g, in cloud storage)
    - Using trust_remote_code=True with Streaming: If the dataset contains custom processing logic (e.g., special decoding functions), you might need to enable trust_remote_code=True: `dataset = load_dataset("path/to/dataset.py", split="train", streaming=True, trust_remote_code=True)`

#### Load dataset: example

```python
import datasets

dataset = datasets.load_dataset("path/to/dataset.py", split="train", streaming=True, trust_remote_code=Treu)
print(dataset["train"][0])  # Access first training example
```

With this flow, `dataset.py` ensures that `datasets.load_dataset()` loads and structures data correctly, making it ready for model training and analysis.

The `datasets.load_dataset()` function interacts with `dataset.py` as follows:

- It **detects the dataset script** and loads the dataset class (`CustomDataset`).
- Calls `_info()` to retrieve dataset metadata.
- Calls `_split_generators()` to determine available dataset splits.
- Calls `_generate_examples()` to yield examples iteratively.

#### Load dataset: Sen1Floods11-Dataset

For [Sen1Floods11-Dataset](https://github.com/EOEPCA/Sen1Floods11-Dataset/):

```python
from datasets import load_dataset
train_data = load_dataset(
    "sen1floods11-dataset/sen1floods11_dataset.py",
    split="train",
    streaming=True,
    trust_remote_code=True,
    config_kwargs={
        "no_cache": False,
        "context": "sen1floods11-dataset/",
    },
)
print(next(iter(train_data)))
```

### DVC integration

It is possible to use DVC in the dataset.py file to pull your data:

```python
from dvc.api import DVCFileSystem

class CustomBuilderConfig(BuilderConfig):
    def __init__(self, version="1.0.0", description=None, **kwargs):
        super().__init__(version=version, description=description)
        config = kwargs.get("config_kwargs")
        self.context = config["context"]

class CustomDataset(datasets.GeneratorBasedBuilder):
    BUILDER_CONFIG_CLASS = CustomBuilderConfig

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.fs = DVCFileSystem(self.config.context)

    ...
```

You can instantiate a DVCFileSystem object so you can pull your data with the method `self.fs.read_bytes(dvc_path)`.
