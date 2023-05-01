# Development

This part of the documentation holds internal information how the image works and
is used for development reference.

## Table of Contents

- [Global Workflow](#global-workflow)

## Global Workflow

```mermaid
flowchart LR
    subgraph INIT
    direction TB
        SHELL["Shell (05)"] --> CONFIG
        CONFIG --> MIGRATION
        MIGRATION --> ENV["Environment (15)"]
        ENV --> DB_INIT
    end
    subgraph MIGRATION["Migration (11)"]
        R{REQUIRED} -->|YES| M_TRUE[Mark for Migration]
        R -->|NO| M_FALSE[Continue]
    end
    subgraph CONFIG["Config (10)"]
        DIR[Configure Directories] --> PARAMS[Validate Params]
    end
    subgraph DB_INIT["Database Init (20)"]
        direction LR
    end
    A[Start] --> INIT
```
