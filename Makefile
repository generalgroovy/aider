.PHONY: validate

validate:
	bash tests/validate-shell.sh
	bash tests/smoke-test.sh
