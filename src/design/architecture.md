# Architecture

SharingHub architecture is organized into three main components:

- **SharingHub UI**:

The "SharingHub UI" is the main entry point. It takes the form of a web portal specially developed to make it easy to discover, browse,
review and download services, code, AI models and datasets.
It dynamically extracts the information stored by users and present it in the best possible way once it has been developed/improved.

- **SharingHub Server**:

The "SharingHub Server" is the engine that supports all the intelligence that enables the portal to carry out its operations.
Its aim is to provide interoperable interfaces that can also be used by external tools, which can then interface with models,
datasets and metrics managed. Thus, the portal backend acts like an enhanced SpatioTemporal Asset Catalog (STAC) that dynamically creates
its content structure from assets stored in different Git repositories. It serves as a bridge between the Git repositories and the STAC
format, enabling users to browse and access datasets within a fully functional STAC structure.

- **GitLab Instance**:

A "GitLab" instance, that can include an activated "MLflow" service, is specifically configured to meet the needs of users,
whether they are developers, AI scientists, or service providers.
All the functionalities of GitLab are retained (Git, DevOps, issue management, code review, etc.), making this component usable
throughout the development, deployment, and maintenance lifecycle of projects and services to implement best development practices,
manage test execution, perform continuous integration, ensure traceability, and reproducibility.

<figure markdown="span">
  ![Architecture](../assets/figures/sharinghub.drawio.png)
  <figcaption>SharingHub Architecture</figcaption>
</figure>
