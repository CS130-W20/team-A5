.PHONY: all build run test

all: build run

build:
	docker build -t rafflebay/backend .

run:
	-pkill docker-compose
	docker-compose up postgres backend
	docker-compose up

run_background:
	-pkill docker-compose
	DATABASE=postgres docker-compose up -d

stop:
	docker-compose down

run_test:
	docker build -t rafflebay/test .
	docker-compose up -d postgres_test test 
	docker-compose exec postgres_test psql -p 5433 -U postgres rafflebay_test -c "DROP TABLE bids, items, users CASCADE;"
	docker-compose down


test:
	docker build -t rafflebay/test .
	-pkill docker-compose
	docker-compose up postgres_test test  


format:
	npx prettier --write --arrow-parens always --single-quote --trailing-comma all --no-bracket-spacing "src/**/*.js"
	npx prettier --write --arrow-parens always --single-quote --trailing-comma all --no-bracket-spacing "test/**/*.js"

# Open shell to the postgres instance
p_shell:
	docker-compose exec postgres psql -U postgres rafflebay

test_p_shell:
	docker-compose exec postgres_test psql -U postgres -p 5433 rafflebay_test

#CAUTION: WILL DELETE ALL DATA
reset_db: 
	docker-compose exec postgres psql -U postgres rafflebay -c "DROP TABLE bids, items, users;"

jsdoc:
	- rm -r JSDoc_Output/
	docker exec -i -t `docker ps -q --filter status=running --filter ancestor=rafflebay/backend:latest` /bin/sh -c "node_modules/jsdoc/jsdoc.js -r src"
	docker cp `docker ps -q --filter status=running --filter ancestor=rafflebay/backend:latest`:/app/out/ ./JSDoc_Output



