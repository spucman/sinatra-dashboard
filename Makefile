.PONY: run
run:
	bundle exec puma -C config/puma.rb

.PONY: run-dev
run-dev:
	rerun 'bundle exec puma -C config/puma.rb'	

.PONY: lint
lint:
	bundle exec rubocop

.PONY: install
install:
	bundle config --local path 'vendor/bundle'
	bundle install

.PONY: test
test:
	bundle exec rspec -I app/web/controllers/rest