all: guest_migration_agent

guest_migration_agent: guest_migration_agent.c
	gcc -Wall -o guest_migration_agent guest_migration_agent.c

.PHONY: clean
clean:
	rm guest_migration_agent
