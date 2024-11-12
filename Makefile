# Makefile - Advanced Laravel Configuration

.PHONY: help serve install migrate seed clear optimize test fresh \
        model controller migration seeder request resource event listener job \
        component policy command middleware factory mail notification rule \
        class view interface service helper dev build

PHP = php
NPM = npm
COMPOSER = composer
ARTISAN = $(PHP) artisan

help:
	@printf "\nUsage: make [command] n=<name> o=<options>\n\nAvailable commands:\n"
	@printf "  build              - Run npm run build.\n"
	@printf "  class              - Create a Class file (Example: make class n=ClassName)\n"
	@printf "  command            - Create an Artisan Command file (Example: make command n=CommandName)\n"
	@printf "  component          - Create a Component file (Example: make component n=ComponentName)\n"
	@printf "  controller         - Create a Controller file (Example: make controller n=ControllerName o=api,resource)\n"
	@printf "  dev                - Run npm run dev.\n"
	@printf "  event              - Create an Event file (Example: make event n=EventName)\n"
	@printf "  factory            - Create a Factory file (Example: make factory n=FactoryName)\n"
	@printf "  fresh              - Refresh all migrations and run seeder.\n"
	@printf "  helper             - Create a Helper class file (Example: make helper n=HelperName)\n"
	@printf "  install            - Install dependencies and setup database.\n"
	@printf "  interface          - Create an Interface file (Example: make interface n=InterfaceName)\n"
	@printf "  job                - Create a Job file (Example: make job n=JobName)\n"
	@printf "  listener           - Create a Listener file (Example: make listener n=ListenerName)\n"
	@printf "  mail               - Create a Mailable file (Example: make mail n=MailName)\n"
	@printf "  migrate            - Run database migrations.\n"
	@printf "  migration          - Create a Migration file (Example: make migration n=MigrationName o=--create=table_name)\n"
	@printf "  model              - Create a Model file (Example: make model n=ModelName o=migration,seeder,factory)\n"
	@printf "  middleware         - Create a Middleware file (Example: make middleware n=MiddlewareName)\n"
	@printf "  notification       - Create a Notification file (Example: make notification n=NotificationName)\n"
	@printf "  policy             - Create a Policy file (Example: make policy n=PolicyName)\n"
	@printf "  request            - Create a Request file (Example: make request n=RequestName)\n"
	@printf "  resource           - Create a Resource file (Example: make resource n=ResourceName o=collection)\n"
	@printf "  rule               - Create a Validation Rule file (Example: make rule n=RuleName)\n"
	@printf "  seeder             - Create a Seeder file (Example: make seeder n=SeederName)\n"
	@printf "  serve              - Start the development server.\n"
	@printf "  service            - Create a Service class (Example: make service n=ServiceName)\n"
	@printf "  test               - Run tests.\n"
	@printf "  view               - Create a View file (Example: make view n=ViewName)\n"

serve:
	@$(ARTISAN) serve
	@printf "Development server started.\n"

install:
	@$(COMPOSER) install
	@$(NPM) install
	@$(ARTISAN) key:generate
	@$(ARTISAN) migrate
	@$(ARTISAN) db:seed
	@printf "Installation completed.\n"

migrate:
	@$(ARTISAN) migrate
	@printf "Migrations executed.\n"

seed:
	@$(ARTISAN) db:seed
	@printf "Seeding completed.\n"

clear:
	@$(ARTISAN) cache:clear
	@$(ARTISAN) config:clear
	@$(ARTISAN) route:clear
	@$(ARTISAN) view:clear
	@printf "All caches cleared!\n"

optimize:
	@$(ARTISAN) optimize
	@$(ARTISAN) config:cache
	@$(ARTISAN) route:cache
	@$(ARTISAN) view:cache
	@printf "Optimization completed.\n"

test:
	@$(PHP) vendor/bin/phpunit --testdox
	@printf "Tests executed.\n"

fresh:
	@$(ARTISAN) migrate:fresh --seed
	@printf "All migrations reset and seeded.\n"

# Model and related files
model:
	@if [ -z "$(n)" ]; then \
		printf "Please specify the model name. Example: make model n=ModelName o=migration,seeder,factory\n"; \
		exit 1; \
	fi
	@if echo "$(o)" | grep -q "migration"; then \
		MIGRATION_FLAG="--migration"; \
	else \
		MIGRATION_FLAG=""; \
	fi; \
	if echo "$(o)" | grep -q "seeder"; then \
		SEEDER_FLAG="--seeder"; \
	else \
		SEEDER_FLAG=""; \
	fi; \
	if echo "$(o)" | grep -q "factory"; then \
		FACTORY_FLAG="--factory"; \
	else \
		FACTORY_FLAG=""; \
	fi; \
	$(ARTISAN) make:model $(n) $$MIGRATION_FLAG $$SEEDER_FLAG $$FACTORY_FLAG; \
	printf "Model and related files created: $(n)\n"

# Controller and related files
controller:
	@if [ -z "$(n)" ]; then \
		printf "Please specify the controller name. Example: make controller n=ControllerName o=api,resource\n"; \
		exit 1; \
	fi
	@if echo "$(o)" | grep -q "resource"; then \
		RESOURCE_FLAG="--resource"; \
	else \
		RESOURCE_FLAG=""; \
	fi; \
	if echo "$(o)" | grep -q "api"; then \
		API_FLAG="--api"; \
	else \
		API_FLAG=""; \
	fi; \
	$(ARTISAN) make:controller $(n) $$RESOURCE_FLAG $$API_FLAG; \
	printf "Controller and related files created: $(n)\n"

# Migration command
migration:
	@if [ -z "$(n)" ]; then \
		printf "Please specify the migration name. Example: make migration n=MigrationName o=--create=table_name\n"; \
		exit 1; \
	fi
	@$(ARTISAN) make:migration $(n) $(o)
	@printf "Migration created: $(n)\n"

# Seeder command
seeder:
	@if [ -z "$(n)" ]; then \
		printf "Please specify the seeder name. Example: make seeder n=SeederName\n"; \
		exit 1; \
	fi
	@$(ARTISAN) make:seeder $(n)
	@printf "Seeder created: $(n)\n"

# Request command
request:
	@if [ -z "$(n)" ]; then \
		printf "Please specify the request name. Example: make request n=RequestName\n"; \
		exit 1; \
	fi
	@$(ARTISAN) make:request $(n)
	@printf "Request created: $(n)\n"

# Resource command
resource:
	@if [ -z "$(n)" ]; then \
		printf "Please specify the resource name. Example: make resource n=ResourceName o=collection\n"; \
		exit 1; \
	fi
	@if echo "$(o)" | grep -q "collection"; then \
		COLLECTION_FLAG="--collection"; \
	else \
		COLLECTION_FLAG=""; \
	fi; \
	$(ARTISAN) make:resource $(n) $$COLLECTION_FLAG; \
	printf "Resource created: $(n)\n"

# Event command
event:
	@if [ -z "$(n)" ]; then \
		printf "Please specify the event name. Example: make event n=EventName\n"; \
		exit 1; \
	fi
	@$(ARTISAN) make:event $(n)
	@printf "Event created: $(n)\n"

# Listener command
listener:
	@if [ -z "$(n)" ]; then \
		printf "Please specify the listener name. Example: make listener n=ListenerName\n"; \
		exit 1; \
	fi
	@$(ARTISAN) make:listener $(n)
	@printf "Listener created: $(n)\n"

# Job command
job:
	@if [ -z "$(n)" ]; then \
		printf "Please specify the job name. Example: make job n=JobName\n"; \
		exit 1; \
	fi
	@$(ARTISAN) make:job $(n)
	@printf "Job created: $(n)\n"

# Component command
component:
	@if [ -z "$(n)" ]; then \
		printf "Please specify the component name. Example: make component n=ComponentName\n"; \
		exit 1; \
	fi
	@$(ARTISAN) make:component $(n)
	@printf "Component created: $(n)\n"

# Policy command
policy:
	@if [ -z "$(n)" ]; then \
		printf "Please specify the policy name. Example: make policy n=PolicyName\n"; \
		exit 1; \
	fi
	@$(ARTISAN) make:policy $(n)
	@printf "Policy created: $(n)\n"

# Command command
command:
	@if [ -z "$(n)" ]; then \
		printf "Please specify the command name. Example: make command n=CommandName\n"; \
		exit 1; \
	fi
	@$(ARTISAN) make:command $(n)
	@printf "Command created: $(n)\n"

# Middleware command
middleware:
	@if [ -z "$(n)" ]; then \
		printf "Please specify the middleware name. Example: make middleware n=MiddlewareName\n"; \
		exit 1; \
	fi
	@$(ARTISAN) make:middleware $(n)
	@printf "Middleware created: $(n)\n"

# Factory command
factory:
	@if [ -z "$(n)" ]; then \
		printf "Please specify the factory name. Example: make factory n=FactoryName\n"; \
		exit 1; \
	fi
	@$(ARTISAN) make:factory $(n)
	@printf "Factory created: $(n)\n"

# Mail command
mail:
	@if [ -z "$(n)" ]; then \
		printf "Please specify the mail name. Example: make mail n=MailName\n"; \
		exit 1; \
	fi
	@$(ARTISAN) make:mail $(n)
	@printf "Mail created: $(n)\n"

# Notification command
notification:
	@if [ -z "$(n)" ]; then \
		printf "Please specify the notification name. Example: make notification n=NotificationName\n"; \
		exit 1; \
	fi
	@$(ARTISAN) make:notification $(n)
	@printf "Notification created: $(n)\n"

# Rule command
rule:
	@if [ -z "$(n)" ]; then \
		printf "Please specify the rule name. Example: make rule n=RuleName\n"; \
		exit 1; \
	fi
	@$(ARTISAN) make:rule $(n)
	@printf "Rule created: $(n)\n"

# Interface command
interface:
	@if [ -z "$(n)" ]; then \
		printf "Please specify the interface name. Example: make interface n=InterfaceName\n"; \
		exit 1; \
	fi
	@$(ARTISAN) make:interface $(n)
	@printf "Interface created: $(n)\n"

# Class command
class:
	@if [ -z "$(n)" ]; then \
		printf "Please specify the class name. Example: make class n=ClassName\n"; \
		exit 1; \
	fi
	@$(ARTISAN) make:class $(n)
	@printf "Class created: $(n)\n"

# Service command
service:
	@if [ -z "$(n)" ]; then \
		printf "Please specify the service name. Example: make service n=ServiceName\n"; \
		exit 1; \
	fi
	@$(ARTISAN) make:class Services/$(n)
	@printf "Service class created in Services directory: $(n)\n"

# Helper command
helper:
	@if [ -z "$(n)" ]; then \
		printf "Please specify the helper name. Example: make helper n=HelperName\n"; \
		exit 1; \
	fi
	@$(ARTISAN) make:class Helpers/$(n)
	@printf "Helper class created in Helpers directory: $(n)\n"

# View command
view:
	@if [ -z "$(n)" ]; then \
		printf "Please specify the view name. Example: make view n=ViewName\n"; \
		exit 1; \
	fi
	@$(ARTISAN) make:view $(n)
	@printf "View created: $(n)\n"

# npm commands
dev:
	@$(NPM) run dev
	@printf "npm run dev executed.\n"

build:
	@$(NPM) run build
	@printf "npm run build executed.\n"
