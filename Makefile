SERVICE_PATH=~/.config/systemd/user/

.PHONY: help
help:
	# SuperLimitBreak system setup
	#  - install - Install and setup all repos
	#  - pull    - Update all repos
	#  - clean   - Delete all repos
	# (Requires docker/git to be installed)


# Install ----------------------------------------------------------------------

.PHONY: install
install: clone services build

.PHONY: clone
clone: libs displayTrigger lightingAutomation voteBattle pentatonicHero


# Repos ------------------------------------------------------------------------

libs:
	git clone https://github.com/calaldees/libs.git

displayTrigger:
	git clone https://github.com/SuperLimitBreak/displayTrigger.git
	cd displayTrigger; make install

lightingAutomation:
	git clone https://github.com/SuperLimitBreak/lightingAutomation.git
	cd lightingAutomation ; make install

voteBattle:
	git clone https://github.com/SuperLimitBreak/voteBattle.git
	cd voteBattle; make install

pentatonicHero:
	git clone https://github.com/SuperLimitBreak/pentatonicHero.git


# Sytemd services --------------------------------------------------------------

.PHONY: services
services: $(SERVICE_PATH)displayTrigger.service $(SERVICE_PATH)lightingAutomation.service $(SERVICE_PATH)voteBattle.service
	if [ -z systemctl ] ; then \
		systemctl --user daemon-reload ;\
	fi

$(SERVICE_PATH)%.service:
	mkdir -p $(SERVICE_PATH)
	cp $*.service $(SERVICE_PATH)

# Pull Updates -----------------------------------------------------------------

.PHONY: pull
pull: clone
	cd libs              ; git pull
	cd displayTrigger    ; git pull
	cd lightingAutomation; git pull
	cd voteBattle        ; git pull
	cd pentatonicHero    ; git pull


# Build ------------------------------------------------------------------------

requirements.pip:
	cat $(find . -name requirements.pip) > requirements.pip

.PHONY: build
build: requirements.pip
	#docker build -t python --file python.Dockerfile .
	#TODO: docker run with names?
	# Unsure if docker is the correct tool.
	# Consider local machine with systemd or docker contaner with systemd
	# Either way the current plan is to configure systemd services


# Run --------------------------------------------------------------------------

.PHONY: start
start:
	#docker-compose up
	


# Clean ------------------------------------------------------------------------

.PHONY: clean
clean:
	rm -rf libs displayTrigger lightingAutomation voteBattle pentatonicHero
	for SERVICE in displayTrigger lightingAutomation voteBattle ; do \
		rm -rf $(SERVICE_PATH)$$SERVICE.service ;\
	done