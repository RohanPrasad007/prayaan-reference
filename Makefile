# =====================================================================================
# PRAYAAN: Reproducibility & Benchmark Execution Makefile
# Tech4Bharat 2026 / GAVS Hackathon — Theme 5: Rural Freight (Problem Statement 5.3)
# =====================================================================================

.PHONY: all verify benchmark unit-economics test-db clean help

PYTHON ?= python3

help:
	@echo "PRAYAAN Build, Test & Verification Targets:"
	@echo "  make verify          Run cost allocation stability verification (verify_cost_allocation.py)"
	@echo "  make benchmark       Run corridor pooling benchmark across seeds (benchmark_simulation.py)"
	@echo "  make unit-economics  Run audited unit economics and 3-year projection (unit_economics.py)"
	@echo "  make test-db         Spin up Postgres 16 PostGIS in Docker and run schema_tests.sql"
	@echo "  make all             Run all algorithmic and economic verification suites"

all: verify benchmark unit-economics

verify:
	$(PYTHON) scripts/verify_cost_allocation.py

benchmark:
	$(PYTHON) scripts/benchmark_simulation.py --seeds 42,1337,2026

unit-economics:
	$(PYTHON) scripts/unit_economics.py

test-db:
	@echo "Starting PostgreSQL 16 + PostGIS container via Docker Compose..."
	docker compose up -d db
	@echo "Awaiting PostgreSQL ready status..."
	@docker compose exec -T db sh -c 'until pg_isready -U postgres -d prayaan; do sleep 1; done'
	@echo "Executing schema invariant and security test suite..."
	docker compose exec -T db psql -U postgres -d prayaan -f /tests/schema_tests.sql
	@echo "Schema verification complete."
