# Dataset with DVC

## Introduction

The most popular Version Control System, [Git](https://git-scm.com/), is not adapted for versioning
large amounts of data, it is not recommended to commit big files in your repository.

When we need to version large amounts of data we use Data Version Control ([DVC](https://dvc.org/)),
that lets you capture the versions of files/directories in your Git repository, while storing them
on-premises or in cloud storage. Each DVC "commit" updates dvc-specific files, and these
modifications can be committed with Git. The real data is then versioned and stored with DVC,
while your Git repository references the "pointer" to this data. The result is a single history
for your source code and data that you can traverse — a proper journal of your work!

The DVC integration offered by SharingHub enables protected access to versioned data,
while respecting the management of data access rights carried out on GitLab,
making it the central point for information management.

## Prerequisites

### Install

First, you must of course install DVC.

Follow their documentation: [Installation](https://dvc.org/doc/install)

### Git repository

When you have access to the `dvc` command, you will need to use it in a Git repository.
You can create one for this tutorial, or use an existing one.

Initialize a repository for the tutorial:

```bash
git init example-dvc
cd example-dvc
touch README.md
git add README.md
git commit -m "Initial commit"
# replace with your own GitLab project url
git remote add origin https://gitlab.example.com/<project-path>.git
git push --set-upstream origin main
```

### GitLab project (Optional)

If you want to use SharingHub integration with DVC, you will need to push your
repository in GitLab. As described [here](../share/examples/dataset-case.md#configuration)
you must add the topic `sharinghub:dataset` to the project.

## Setup DVC

### Init

The first step is to initialize the DVC configuration.

```bash
dvc init
```

The configuration itself is not ignored by Git, as you need to share it with other users.
The authentication credentials on the other hand will be ignored for obvious security purposes.

### Configure remote

You will now need to configure a remote storage and the appropriate authentication.

#### SharingHub

You can use SharingHub as the remote storage of DVC. In your project page you can find
a [code generator](../explore/project-view.md#dvc) to help you for the setup.

<figure markdown>
  ![Architecture](../assets/figures/explore/project-view/dvc-helper.png)
  <figcaption>DVC helper</figcaption>
</figure>

Copy the project's unique identifier (`<project_id>`) by connecting to the GitLab interface
via the URL `https://gitlab.example.com/<project-path>`.

![gitlab_project_id.png](../assets/figures/tutorials/gitlab-project-id.png)

This ID is necessary to identify the storage path for DVC, you can continue the configuration.

```bash
# replace with your sharinghub URL and the correct project ID
dvc remote add --default sharinghub https://sharinghub.example.com/api/store/<project_id>
dvc remote modify sharinghub auth custom
dvc remote modify sharinghub custom_auth_header 'X-Gitlab-Token'
```

You can commit and push the DVC configuration:

```bash
git add .
git commit -m "Initialize DVC"
git push origin main
```

Finally, configure your authentication credentials with a GitLab access token, you will need
at least the `read_api` permission.

```bash
dvc remote modify --local sharinghub password <your-personal-gitlab-token>
```

#### S3 bucket

!!! warning
    Usage of a custom DVC remote such as your own S3 bucket will impact the easiness of sharing
    for your project. To be more clear, access to that bucket will require the credentials of the
    bucket, and it is not tied to our "GitLab-centered" philosophy. Be sure to address this
    problem by properly documenting how to retrieve the credentials.

You can alternatively chose to use an S3 bucket for the storage. In order to be able to use this
bucket for other repositories use a subpath in the bucket path.
It could be the project ID, path, name, slug etc...

```bash
dvc remote add --default my-bucket s3://<bucket>/<project-identifier>
dvc remote modify my-bucket endpointurl <s3-endpoint-url>
```

Now commit and push the DVC configuration:

```bash
git add .
git commit -m "Initialize DVC"
git push origin main
```

Configure the remote credentials with your S3 access key id and secret access key.

```bash
dvc remote modify --local my-bucket access_key_id <access-key-id>
dvc remote modify --local my-bucket secret_access_key <secret-access-key>
```

## Usage

### Tracking data

The use of DVC is simple, but because it it used alongside Git you must always be rigorous and not
forget to use it correctly.

Let's pick a piece of data to work with. We'll create a file, `very_big_file.txt`, in the `data` directory.

```bash
mkdir data
echo "Very big content" > data/very_big_file.txt
```

Use `dvc add` to start tracking the dataset:

```bash
dvc add data
```

DVC stores information about the added file in a special `.dvc` file named `data.dvc`. This small, human-readable metadata file acts as a placeholder for the original data for the purpose of Git tracking. You can track files or directories.

Next, run the following commands to track changes in Git:

```bash
git add data.dvc .gitignore
git commit -m "Add data"
dvc push
git push
```

Now, we can modify the data.

```bash
echo "Very big content but different" > data/very_big_file.txt
```

Update DVC tracking:

```bash
dvc add data
```

You will notice that `data.dvc` was modified to reflect that the data changed.
To finalize the update, commit and push.

```bash
git add data.dvc
git commit -m "Modify data"
dvc push
git push
```

By combining Git and DVC, if you go back to the previous commit you can synchronize the data
to the previous version.

```bash
git checkout HEAD~1
dvc checkout
```

### Retrieving data

To retrieve the managed data:

* Clone the Git project.

    ```bash
    git clone https://gitlab.example.com/<project-path>
    cd <project-dir>
    ```

* Configure authentication credentials as described in the section [Configure remote](#configure-remote).

    ```bash
    # Credentials setup for SharingHub integration
    dvc remote modify --local sharinghub password <your-personal-gitlab-token>
    ```

* Download the data through `dvc pull`.

    ```bash
    dvc pull
    ```
