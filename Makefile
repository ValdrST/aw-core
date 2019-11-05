.PHONY: build test benchmark typecheck typecheck-strict clean

pip_install_args := . -r requirements.txt

ifdef DEV
pip_install_args := --editable $(pip_install_args)
endif

build:
	pip3 install $(pip_install_args)

lock:
	pipenv lock -r > requirements.txt
	pipenv lock -r -d > requirements-dev.txt

test:
	python3 -m pytest tests -v --cov=aw_core --cov=aw_datastore --cov=aw_transform --cov=aw_query

coverage_html: test
	python3 -m coverage html -d coverage_html

benchmark:
	python3 -m aw_datastore.benchmark

typecheck:
	export MYPYPATH=./stubs; python3 -m mypy aw_core aw_datastore aw_transform aw_query --show-traceback --ignore-missing-imports --follow-imports=skip

typecheck-strict:
	export MYPYPATH=./stubs; python3 -m mypy aw_core aw_datastore aw_transform aw_query --strict-optional --check-untyped-defs; echo "Not a failing step"

clean:
	rm -rf build dist
	rm -rf aw_core/__pycache__ aw_datastore/__pycache__
