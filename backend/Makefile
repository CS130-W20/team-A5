.PHONY: all build run test

all: build run

build:
	docker build -t rafflebay/backend .

run:
	-pkill docker-compose
<<<<<<< HEAD
	docker-compose up
||||||| constructed merge base
	DATABASE=postgres docker-compose up
=======
	docker-compose up postgres backend
>>>>>>> Fully fixed docker

run_background:
	-pkill docker-compose
	DATABASE=postgres docker-compose up -d

stop:
	docker-compose down

stop_test:
	docker-compose down

test:
	docker build -t rafflebay/test .
	-pkill docker-compose
	docker-compose up postgres_test test  

run_test:
	docker exec -i -t `docker ps -q --filter status=running --filter ancestor=rafflebay/backend:latest` /bin/sh -c "npm run test"
	DATABASE=postgres_test docker-compose up

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



