UUID = $(shell grep uuid metadata.json | cut -d'"' -f4)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install-home: ## Install in ~/.local/share/gnome-shell/extensions/
	mkdir -p $(HOME)/.local/share/gnome-shell/extensions/$(UUID)
	cp metadata.json extension.js stylesheet.css $(HOME)/.local/share/gnome-shell/extensions/$(UUID)

