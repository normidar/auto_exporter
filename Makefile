.PHONY: pub_get
pub_get: ## Run pub get for all packages: `make pub_get`
	fvm dart pub get
	@for dir in packages/*/; do \
		if [ -f "$$dir/pubspec.yaml" ]; then \
			echo "Running pub get in $$dir..."; \
			(cd "$$dir" && fvm dart pub get); \
			if [ -f "$$dir/example/pubspec.yaml" ]; then \
				echo "Running pub get in $$dir/example..."; \
				(cd "$$dir/example" && fvm dart pub get); \
			fi \
		fi \
	done

.PHONY: format
format:
	fvm dart format .

.PHONY: analyze
analyze:
	fvm dart analyze .
