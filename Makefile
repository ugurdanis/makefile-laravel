# Makefile - Advanced Laravel Configuration

.PHONY: help serve install migrate seed clear optimize test fresh \
        model controller migration seeder request resource event listener job \
        component policy command middleware factory mail notification rule \
        class view interface service helper dev build

# Project variables
COMPOSER = composer
PHP = php
NPM = npm
ARTISAN = $(PHP) artisan

# Show help
help:
	@printf "\nUsage: make [command] n=<name> o=<options>\n\nAvailable commands:\n"
	@printf "  serve              - Start the development server.\n"
	@printf "  install           - Install dependencies and setup database.\n"
	@printf "  migrate           - Run database migrations.\n"
	@printf "  seed              - Run database seeders.\n"
	@printf "  fresh             - Refresh all migrations and run seeder.\n"
	@printf "  clear             - Clear application cache.\n"
	@printf "  optimize          - Cache config, routes and views.\n"
	@printf "  test              - Run tests.\n"
	@printf "  clean             - Clean temporary files.\n"
	@printf "  cache             - Clear and cache everything.\n"
	@printf "  ide               - Generate IDE helper files.\n"
	@printf "  lint              - Run code style checks.\n"
	@printf "  fix               - Fix code style issues.\n"
	@printf "  dev               - Run npm run dev.\n"
	@printf "  build              - Run npm run build.\n"
	@printf "\nLaravel Make Commands:\n"
	@printf "  controller         - Create a Controller file (Example: make controller n=ControllerName o=api,resource)\n"
	@printf "  model             - Create a Model file (Example: make model n=ModelName o=migration,seeder,factory)\n"
	@printf "  migration         - Create a Migration file (Example: make migration n=MigrationName o=--create=table_name)\n"
	@printf "  seeder            - Create a Seeder file (Example: make seeder n=SeederName)\n"
	@printf "  request           - Create a Request file (Example: make request n=RequestName)\n"
	@printf "  resource          - Create a Resource file (Example: make resource n=ResourceName o=collection)\n"
	@printf "  event             - Create an Event file (Example: make event n=EventName)\n"
	@printf "  listener          - Create a Listener file (Example: make listener n=ListenerName)\n"
	@printf "  job               - Create a Job file (Example: make job n=JobName)\n"
	@printf "  component         - Create a Component file (Example: make component n=ComponentName)\n"
	@printf "  policy            - Create a Policy file (Example: make policy n=PolicyName)\n"
	@printf "  command           - Create an Artisan Command file (Example: make command n=CommandName)\n"
	@printf "  middleware        - Create a Middleware file (Example: make middleware n=MiddlewareName)\n"
	@printf "  factory           - Create a Factory file (Example: make factory n=FactoryName)\n"
	@printf "  mail              - Create a Mailable file (Example: make mail n=MailName)\n"
	@printf "  notification      - Create a Notification file (Example: make notification n=NotificationName)\n"
	@printf "  rule              - Create a Validation Rule file (Example: make rule n=RuleName)\n"
	@printf "  interface         - Create an Interface file (Example: make interface n=InterfaceName)\n"
	@printf "  class             - Create a Class file (Example: make class n=ClassName)\n"
	@printf "  service           - Create a Service class (Example: make service n=ServiceName)\n"
	@printf "  helper            - Create a Helper class file (Example: make helper n=HelperName)\n"
	@printf "  view              - Create a View file (Example: make view n=ViewName)\n"

# Install project dependencies
install:
	@echo "Installing project dependencies..."
	$(COMPOSER) install
	$(NPM) install
	$(ARTISAN) key:generate
	$(ARTISAN) migrate
	$(ARTISAN) db:seed
	@echo "Installation completed!"

# Set up development environment
dev:
	@$(NPM) run dev
	@printf "npm run dev executed.\n"

# Set up production environment
prod:
	@echo "Setting up production environment..."
	cp .env.production .env
	$(ARTISAN) migrate --force
	$(ARTISAN) storage:link
	$(NPM) run build
	@echo "Production environment ready!"

# Run tests
test:
	@$(PHP) vendor/bin/phpunit --testdox
	@printf "Tests executed.\n"

# Clean temporary files and caches
clean:
	@echo "Cleaning temporary files..."
	rm -rf vendor
	rm -rf node_modules
	rm -rf bootstrap/cache/*.php
	rm -rf storage/framework/cache/*
	rm -rf storage/framework/sessions/*
	rm -rf storage/framework/views/*
	rm -rf storage/logs/*
	@echo "Cleaning completed!"

# Run database migrations
migrate:
	@echo "Running database migrations..."
	$(ARTISAN) migrate

# Run database seeders
seed:
	@echo "Running database seeders..."
	$(ARTISAN) db:seed

# Clear and cache everything
cache:
	@echo "Clearing and caching..."
	$(ARTISAN) optimize:clear
	$(ARTISAN) config:cache
	$(ARTISAN) route:cache
	$(ARTISAN) view:cache
	@echo "Cache operations completed!"

# Generate IDE helper files
ide:
	@echo "Generating IDE helper files..."
	$(ARTISAN) ide-helper:generate
	$(ARTISAN) ide-helper:meta
	$(ARTISAN) ide-helper:models --nowrite

# Run code style checks
lint:
	@echo "Running code style checks..."
	./vendor/bin/pint --test

# Fix code style issues
fix:
	@echo "Fixing code style issues..."
	./vendor/bin/pint

# Start development server
serve:
	@$(ARTISAN) serve
	@printf "Development server started.\n"

# Clear application cache
clear:
	@echo "Clearing application cache..."
	$(ARTISAN) cache:clear
	$(ARTISAN) config:clear
	$(ARTISAN) route:clear
	$(ARTISAN) view:clear
	@echo "Cache cleared!"

# Create a new controller
controller:
	@if [ -z "$(n)" ]; then \
		echo "Please specify the controller name. Example: make controller n=ControllerName o=api,resource"; \
	else \
		OPTIONS=""; \
		if [ ! -z "$(o)" ]; then \
			if echo "$(o)" | grep -q "resource"; then \
				OPTIONS="$$OPTIONS --resource"; \
			fi; \
			if echo "$(o)" | grep -q "api"; then \
				OPTIONS="$$OPTIONS --api"; \
			fi; \
		fi; \
		$(ARTISAN) make:controller $(n) $$OPTIONS; \
		echo "Controller created: $(n)"; \
	fi

# Create a new model
model:
	@if [ -z "$(n)" ]; then \
		echo "Please specify the model name. Example: make model n=ModelName o=migration,factory,seed"; \
	else \
		OPTIONS=""; \
		if [ ! -z "$(o)" ]; then \
			if echo "$(o)" | grep -q "migration"; then \
				OPTIONS="$$OPTIONS -m"; \
			fi; \
			if echo "$(o)" | grep -q "factory"; then \
				OPTIONS="$$OPTIONS -f"; \
			fi; \
			if echo "$(o)" | grep -q "seed"; then \
				OPTIONS="$$OPTIONS -s"; \
			fi; \
		fi; \
		$(ARTISAN) make:model $(n) $$OPTIONS; \
		echo "Model created: $(n)"; \
	fi

# Migration command
migration:
	@if [ -z "$(n)" ]; then \
		echo "Please specify the migration name. Example: make migration n=create_users_table o=--create=users"; \
	else \
		$(ARTISAN) make:migration $(n) $(o); \
		echo "Migration created: $(n)"; \
	fi

# Seeder command
seeder:
	@if [ -z "$(n)" ]; then \
		echo "Please specify the seeder name. Example: make seeder n=UsersTableSeeder"; \
	else \
		$(ARTISAN) make:seeder $(n); \
		echo "Seeder created: $(n)"; \
	fi

# Request command
request:
	@if [ -z "$(n)" ]; then \
		echo "Please specify the request name. Example: make request n=StoreUserRequest"; \
	else \
		$(ARTISAN) make:request $(n); \
		echo "Request created: $(n)"; \
	fi

# Resource command
resource:
	@if [ -z "$(n)" ]; then \
		echo "Please specify the resource name. Example: make resource n=UserResource o=collection"; \
	else \
		OPTIONS=""; \
		if [ ! -z "$(o)" ] && echo "$(o)" | grep -q "collection"; then \
			OPTIONS="--collection"; \
		fi; \
		$(ARTISAN) make:resource $(n) $$OPTIONS; \
		echo "Resource created: $(n)"; \
	fi

# Event command
event:
	@if [ -z "$(n)" ]; then \
		echo "Please specify the event name. Example: make event n=UserRegistered"; \
	else \
		$(ARTISAN) make:event $(n); \
		echo "Event created: $(n)"; \
	fi

# Listener command
listener:
	@if [ -z "$(n)" ]; then \
		echo "Please specify the listener name. Example: make listener n=SendWelcomeEmail"; \
	else \
		$(ARTISAN) make:listener $(n); \
		echo "Listener created: $(n)"; \
	fi

# Job command
job:
	@if [ -z "$(n)" ]; then \
		echo "Please specify the job name. Example: make job n=ProcessPodcast"; \
	else \
		$(ARTISAN) make:job $(n); \
		echo "Job created: $(n)"; \
	fi

# Component command
component:
	@if [ -z "$(n)" ]; then \
		echo "Please specify the component name. Example: make component n=Alert"; \
	else \
		$(ARTISAN) make:component $(n); \
		echo "Component created: $(n)"; \
	fi

# Policy command
policy:
	@if [ -z "$(n)" ]; then \
		echo "Please specify the policy name. Example: make policy n=PostPolicy"; \
	else \
		$(ARTISAN) make:policy $(n); \
		echo "Policy created: $(n)"; \
	fi

# Command command
command:
	@if [ -z "$(n)" ]; then \
		echo "Please specify the command name. Example: make command n=SendEmails"; \
	else \
		$(ARTISAN) make:command $(n); \
		echo "Command created: $(n)"; \
	fi

# Middleware command
middleware:
	@if [ -z "$(n)" ]; then \
		echo "Please specify the middleware name. Example: make middleware n=EnsureTokenIsValid"; \
	else \
		$(ARTISAN) make:middleware $(n); \
		echo "Middleware created: $(n)"; \
	fi

# Factory command
factory:
	@if [ -z "$(n)" ]; then \
		echo "Please specify the factory name. Example: make factory n=PostFactory"; \
	else \
		$(ARTISAN) make:factory $(n); \
		echo "Factory created: $(n)"; \
	fi

# Mail command
mail:
	@if [ -z "$(n)" ]; then \
		echo "Please specify the mail name. Example: make mail n=OrderShipped"; \
	else \
		$(ARTISAN) make:mail $(n); \
		echo "Mail created: $(n)"; \
	fi

# Notification command
notification:
	@if [ -z "$(n)" ]; then \
		echo "Please specify the notification name. Example: make notification n=InvoicePaid"; \
	else \
		$(ARTISAN) make:notification $(n); \
		echo "Notification created: $(n)"; \
	fi

# Rule command
rule:
	@if [ -z "$(n)" ]; then \
		echo "Please specify the rule name. Example: make rule n=Uppercase"; \
	else \
		$(ARTISAN) make:rule $(n); \
		echo "Rule created: $(n)"; \
	fi

# Interface command
interface:
	@if [ -z "$(n)" ]; then \
		echo "Please specify the interface name. Example: make interface n=RepositoryInterface"; \
	else \
		mkdir -p app/Contracts; \
		$(ARTISAN) make:interface $(n) --path=app/Contracts; \
		echo "Interface created in Contracts directory: $(n)"; \
	fi

# Class command
class:
	@if [ -z "$(n)" ]; then \
		echo "Please specify the class name. Example: make class n=CustomClass"; \
	else \
		$(ARTISAN) make:class $(n); \
		echo "Class created: $(n)"; \
	fi

# Service command
service:
	@if [ -z "$(n)" ]; then \
		echo "Please specify the service name. Example: make service n=PaymentService"; \
	else \
		mkdir -p app/Services; \
		$(ARTISAN) make:class Services/$(n); \
		echo "Service class created in Services directory: $(n)"; \
	fi

# Helper command
helper:
	@if [ -z "$(n)" ]; then \
		echo "Please specify the helper name. Example: make helper n=StringHelper"; \
	else \
		mkdir -p app/Helpers; \
		$(ARTISAN) make:class Helpers/$(n); \
		echo "Helper class created in Helpers directory: $(n)"; \
	fi

# View command
view:
	@if [ -z "$(n)" ]; then \
		echo "Please specify the view name. Example: make view n=pages/about"; \
	else \
		mkdir -p resources/views/$(shell dirname $(n)); \
		touch resources/views/$(n).blade.php; \
		echo "View created: resources/views/$(n).blade.php"; \
	fi

# Fresh database
fresh:
	@$(ARTISAN) migrate:fresh --seed
	@printf "All migrations reset and seeded.\n"

# Default target
all: install

# Optimize command
optimize:
	@$(ARTISAN) optimize
	@$(ARTISAN) config:cache
	@$(ARTISAN) route:cache
	@$(ARTISAN) view:cache
	@printf "Optimization completed.\n"

# Build command
build:
	@$(NPM) run build
	@printf "npm run build executed.\n"