#
# Cross Platform Makefile
# Compatible with MSYS2/MINGW, Ubuntu 14.04.1 and Mac OS X
#
# You will need SDL2 (http://www.libsdl.org):
# Linux:
#   apt-get install libsdl2-dev
# Mac OS X:
#   brew install sdl2
# MSYS2:
#   pacman -S mingw-w64-i686-SDL2
#

#CXX = g++
#CXX = clang++

PARENT_BRANCH = main
STAGE = debug

EXE_DIR = bin
EXE = example_sdl_sdlrenderer
OBJS_DIR = obj

IMGUI_DIR = imgui
IMGUI_OBJS_DIR = imgui

GUI_DIR = gui

SOURCES = main.cpp
SOURCES += $(GUI_DIR)/imgui/main_menu_bar.cpp $(GUI_DIR)/imgui/imgui.cpp

IMGUI_SOURCES = $(IMGUI_DIR)/imgui.cpp $(IMGUI_DIR)/imgui_demo.cpp $(IMGUI_DIR)/imgui_draw.cpp $(IMGUI_DIR)/imgui_tables.cpp $(IMGUI_DIR)/imgui_widgets.cpp
IMGUI_SOURCES += $(IMGUI_DIR)/backends/imgui_impl_sdl.cpp $(IMGUI_DIR)/backends/imgui_impl_sdlrenderer.cpp

OBJS_O = $(addsuffix .o, $(basename $(notdir $(SOURCES))))
OBJS = $(addprefix $(OBJS_DIR)/$(STAGE)/, $(OBJS_O))

IMGUI_OBJS_O = $(addsuffix .o, $(basename $(notdir $(IMGUI_SOURCES))))
IMGUI_OBJS = $(addprefix $(OBJS_DIR)/$(STAGE)/$(IMGUI_OBJS_DIR)/, $(IMGUI_OBJS_O))

UNAME_S := $(shell uname -s)

CXXFLAGS = -std=c++11 -I$(IMGUI_DIR) -I$(IMGUI_DIR)/backends
CXXFLAGS += -g -Wall -Wformat
LIBS =

##---------------------------------------------------------------------
## BUILD FLAGS PER PLATFORM
##---------------------------------------------------------------------

ifeq ($(UNAME_S), Linux) #LINUX
	ECHO_MESSAGE = "Linux"
	LIBS += -lGL -ldl `sdl2-config --libs`

	CXXFLAGS += `sdl2-config --cflags`
	CFLAGS = $(CXXFLAGS)
endif

ifeq ($(UNAME_S), Darwin) #APPLE
	ECHO_MESSAGE = "Mac OS X"
	LIBS += -framework OpenGL -framework Cocoa -framework IOKit -framework CoreVideo `sdl2-config --libs`
	LIBS += -L/usr/local/lib -L/opt/local/lib

	CXXFLAGS += `sdl2-config --cflags`
	CXXFLAGS += -I/usr/local/include -I/opt/local/include
	CFLAGS = $(CXXFLAGS)
endif

ifeq ($(OS), Windows_NT)
	ECHO_MESSAGE = "MinGW"
	LIBS += -lgdi32 -lopengl32 -limm32 `pkg-config --static --libs sdl2`

	CXXFLAGS += `pkg-config --cflags sdl2`
	CFLAGS = $(CXXFLAGS)
endif

##---------------------------------------------------------------------
## BUILD RULES
##---------------------------------------------------------------------

$(OBJS_DIR)/$(STAGE)/%.o:%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

$(OBJS_DIR)/$(STAGE)/$(IMGUI_OBJS_DIR)/%.o:$(IMGUI_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

$(OBJS_DIR)/$(STAGE)/$(IMGUI_OBJS_DIR)/%.o:$(IMGUI_DIR)/backends/%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

$(OBJS_DIR)/$(STAGE)/%.o:$(GUI_DIR)/imgui/%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

all: $(EXE_DIR)/$(STAGE)/$(EXE) 
	@echo Build complete for $(ECHO_MESSAGE)

$(EXE_DIR)/$(STAGE)/$(EXE): $(OBJS) $(IMGUI_OBJS)
	$(CXX) -o $@ $^ $(CXXFLAGS) $(LIBS)

clean:
	rm -f $(EXE_DIR)/$(STAGE)/$(EXE) $(OBJS) $(IMGUI_OBJS)

git-pull:
	git submodule foreach --recursive 'git pull --rebase origin'

git-checkout:
	@echo Checkout submodules to ${PARENT_BRANCH}
	git submodule update --remote --recursive --init
	git submodule foreach -q --recursive 'echo submodule $$name; git checkout $$(git config -f $$toplevel/.gitmodules submodule.$$name.branch || echo ${PARENT_BRANCH}); echo \\n'
