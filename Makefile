GAME_NAME = space-shooter
LOVE_FILE = $(GAME_NAME).love

SRC = . \
      assets \
      libs

all: $(LOVE_FILE)

$(LOVE_FILE):
	zip -9 -r $(LOVE_FILE) $(SRC) \
		-x "*.git*" "*DS_Store" "*.swp" "*/__pycache__/*"

run: $(LOVE_FILE)
	love $(LOVE_FILE)

clean:
	rm -f $(LOVE_FILE)
