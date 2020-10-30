dev: dev-server dev-client
dev-server:
	docker-compose -f build-automation/WirtBot/compose/dev.yml up -d --build --remove-orphans 
dev-client: 
	cd ./Interface && npm run dev
dev-website: 
	cd ./Website && npm run dev
dev-setup:
	cd ./shared-libs/crypto && npm install && npm run build && cd - && \
	cd ./shared-libs/config-generators && npm install && npm run build || cd - && \
	cd ./Website && npm install && cd - && \
	cd ./Installer && npm install && cd - && \
	cd ./Interface && npm install && cd -

run-test-wirtbot: 
	docker-compose -f build-automation/WirtBot/compose/example.yml up --abort-on-container-exit --build --remove-orphans

test-system: 
	docker-compose -f build-automation/System-Tests/compose/test.yml up --abort-on-container-exit --build --remove-orphans
test-wirtbot:
	cd WirtBot && cargo test && cd -
test-wirtbot-dev:
	cd WirtBot && cargo watch -x test
test-wirtbot-ci:
	docker-compose -f build-automation/WirtBot/compose/test.yml up  --remove-orphans --build test_wirtbot
