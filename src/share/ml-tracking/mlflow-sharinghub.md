# :simple-mlflow: MLflow SharingHub

MLflow is a platform to streamline machine learning development, including tracking experiments, packaging code into reproducible runs, and sharing and deploying models.

For SharingHub, we developed a plugin for MLflow, MLflow SharingHub, that enables model tracking per AI Model project in SharingHub. To be more clear, each AI model project in SharingHub have a corresponding MLflow tracking URI, like `https://sharinghub.example.com/mlflow/<gitlab-project-path>/tracking/`.

## Permissions

The permission system is based on the permission system of SharingHub, based upon GitLab. That means only collaborators of the GitLab repository can use the tracking URI, people with read-only access on the project will have read-only access in mlflow, and no access will not display anything.

Permissions mapping with GitLab (for experiments, runs, model registry...):

- Create: Owner, Maintainer, Developer
- Read: Owner, Maintainer, Developer, Reporter, Guest
- Update: Owner, Maintainer, Developer
- Delete: Owner, Maintainer, Developer

## Authentication

MLflow SharingHub uses SharingHub authentication session, meaning that **if you login in SharingHub, you should also be authenticated in MLflow SharingHub**.

## Limitations

It is important to note that there are some _limitations_ and _constraints_ on MLflow SharingHub. It is a plugin, on _top_ of MLflow, meaning MLflow particularities impose restrictions. Despite having multiple tracking URIs, we have a single server and database. In MLflow, experiments names, and model names (model registry) are _unique_, if I name an experiment, no one can create another experiment with the same name.

If you use MLflow SharingHub, and use project A tracking URI, another person on project B could want to use the same name as you for an experiment, creating name collision, throwing an error. **MLflow experiments and models (in Model Registry) requires a suffix with the GitLab project ID**, of the format `<experiment-name> (<project-id>)`. This avoid collision across all projects.

!!! note
    An important thing to note is that your SharingHub may be configured with MLflow SharingHub integration, and the code generator in the [MLflow helper](../../explore/project-view.md#mlflow) will use MLflow SharingHub as a tracking URI in the snippets generated. The experiment name generated in the snippet will also contains automatically the project ID! Be sure to check this helper!
