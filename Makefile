build: components lib
	@rm -rf dist
	@mkdir dist
	@coffee -o dist -c lib/*.coffee
	@component build --standalone mixer
	@mv build/build.js mixer.js
	@rm -rf build
	@node_modules/.bin/uglifyjs -nc --unsafe -mt -o mixer.min.js mixer.js
	@echo "File size (minified): " && cat mixer.min.js | wc -c
	@echo "File size (gzipped): " && cat mixer.min.js | gzip -9f  | wc -c

components: component.json
	@component install --dev

clean:
	rm -fr components