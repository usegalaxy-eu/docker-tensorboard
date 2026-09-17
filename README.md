# docker-tensorboard

This repository builds a Docker image for TensorBoard 2.21.0
based on the [PR95](https://github.com/conda-forge/tensorboard-feedstock/pull/95) 
in the conda-forge tensorboard-feedstock. 

The PR bumps TensorBoard from 2.20.0 to 2.21.0 which fixes the 
> ModuleNotFoundError: No module named `pkg_resources` 

error occurring with recent versions of `setuptools` (> 81.0.0).

Build it with:

```bash
docker build -t quay.io/galaxy/tensorboard:2.21.0-pr95 . 
```

Test it with:

```bash
docker run --rm quay.io/galaxy/tensorboard:2.21.0-pr95 \
    python -c '
        import sys
        import setuptools
        import tensorboard

        print("Python:", sys.version)
        print("TensorBoard:", tensorboard.__version__)
        print("setuptools:", setuptools.__version__)
    '
    pip check
```

Run the tensorboard server with:

```bash
docker run --rm -p 6006:6006 -v "$PWD/tensorboard_logs:/logs:ro" \
    quay.io/galaxy/tensorboard:2.21.0-pr95 \
    tensorboard --logdir /logs --host 0.0.0.0 --port 6006
```