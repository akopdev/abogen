.EXPORT_ALL_VARIABLES: ; 
.PHONY: all
.DEFAULT_GOAL: help

UV = uv
UVR = @$(UV) run --extra "dev"

help:
	@echo '================================================='
	@echo '~~ List of available commands for this project ~~'
	@echo '================================================='
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'
	 
build: ## Build desktop app
	$(UV) venv
	$(UV) pip install pip
	$(UVR) spacy download en_core_web_sm
	$(UVR) pyinstaller --clean \
										 --onefile \
										 --windowed \
										 --icon abogen/assets/icon.icns \
										 --add-data "abogen/assets:abogen/assets" \
										 --add-data "abogen/VERSION:." \
										 --add-data ".venv/lib/python3.11/site-packages/espeakng_loader/espeak-ng-data:espeakng_loader/espeak-ng-data" \
										 --add-data ".venv/lib/python3.11/site-packages/en_core_web_sm:en_core_web_sm" \
										 --name abogen \
										 abogen/main.py 

clean: ## Remove all file artifacts
	@rm -rf .venv/ dist/ build/ *.egg-info .pytest_cache/ .coverage coverage.xml
	@find . -type f -name "*.py[co]" -delete
	@find . -type d -name "__pycache__" -delete
	@find . -name '*~' -delete
