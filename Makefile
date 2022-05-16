make: 
	redoc-cli bundle -o docs/_static/iris_api_reference_v1.0.0.html docs/api_reference/reference/iris.v1.0.0.yaml
	redoc-cli bundle -o docs/_static/iris_api_reference_v1.0.1.html docs/api_reference/reference/iris.v1.0.1.yaml
	redoc-cli bundle -o docs/_static/iris_api_reference_v1.0.2.html docs/api_reference/reference/iris.v1.0.2.yaml
	redoc-cli bundle -o docs/_static/iris_api_reference_v1.0.3.html docs/api_reference/reference/iris.v1.0.3.yaml
	mkdocs build
