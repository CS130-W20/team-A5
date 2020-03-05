.PHONY: all build run test

all: build run

build:
	docker build -t rafflebay/backend .

run:
	-pkill docker-compose
	DATABASE=postgres docker-compose up

run_background:
	-pkill docker-compose
	docker-compose up -d

stop:
	docker-compose down

test:
	docker build -t rafflebay/test .
	-pkill docker-compose
	DATABASE=postgres_test docker-compose up

format:
	npx prettier --write --arrow-parens always --single-quote --trailing-comma all --no-bracket-spacing "src/**/*.js"
	npx prettier --write --arrow-parens always --single-quote --trailing-comma all --no-bracket-spacing "test/**/*.js"

# Open shell to the postgres instance
p_shell:
	DATABASE=postgres docker-compose exec postgres psql -U postgres rafflebay

#CAUTION: WILL DELETE ALL DATA
reset_db: 
	DATABASE=postgres docker-compose exec postgres psql -U postgres rafflebay -c "DROP TABLE payments, shipments, bids, items, users;"

jsdoc:
	- rm -r JSDoc_Output/
	docker exec -i -t `docker ps -q --filter status=running --filter ancestor=rafflebay/backend:latest` /bin/sh -c "node_modules/jsdoc/jsdoc.js -r src"
	docker cp `docker ps -q --filter status=running --filter ancestor=rafflebay/backend:latest`:/app/out/ ./JSDoc_Output



