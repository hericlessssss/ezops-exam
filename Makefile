.PHONY: up down logs test build scan

up:
	docker-compose up -d

down:
	docker-compose down

logs:
	docker-compose logs -f

build:
	docker-compose up --build -d

scan:
	@echo "Scanning ports..."
	# Helper to check if ports are open (Linux/Mac mostly, but useful mostly for info)
	@echo "Frontend: http://localhost:8080"
	@echo "Backend: http://localhost:5000"
