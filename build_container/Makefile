build:
	rm -rf restore.sh || true
	cp  ../restore.sh restore.sh
	docker build -t nutellinoit/sidecar-restore-volumes:dev .
	rm -rf restore.sh || true

