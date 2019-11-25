RELEASE_TYPE: patch

autoscaling module:

*   This is a new module, meant to replace a module from the old terraform-modules repo.

service, task_definition modules:

*   Tweaks to type constraints in variables so they don't emit a deprecation warning
    from Terraform.  There should be no user visible change.