# docker-tensorboard

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