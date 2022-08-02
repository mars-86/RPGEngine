#include "../../imgui/imgui.h"
#include "../../imgui/backends/imgui_impl_sdl.h"
#include "../../imgui/backends/imgui_impl_sdlrenderer.h"

bool show_file_new_item = false;
bool show_help_about_item = false;

void mainMenuBar(void) {
    if(ImGui::BeginMainMenuBar())
    {
        if(ImGui::BeginMenu("File"))
        {    
            ImGui::MenuItem("New", NULL, &show_file_new_item);
            ImGui::EndMenu();
        }
        if(ImGui::BeginMenu("Edit"))
        {    
            // ImGui::MenuItem("New", NULL, &show_file_new_item);
            ImGui::EndMenu();
        }
        if(ImGui::BeginMenu("Help"))
        {    
            ImGui::MenuItem("About", NULL, &show_help_about_item);
            ImGui::EndMenu();
        }
        ImGui::EndMainMenuBar();    
    }

    if (show_file_new_item)
    {
        ImGui::Begin("New Window", &show_file_new_item);   // Pass a pointer to our bool variable (the window will have a closing button that will clear the bool when clicked)
        ImGui::Text("Hello from new window!");
        if (ImGui::Button("Close Me"))
            show_file_new_item = false;
        ImGui::End();
    }

    if (show_help_about_item)
    {
        ImGui::Begin("New Window", &show_help_about_item);   // Pass a pointer to our bool variable (the window will have a closing button that will clear the bool when clicked)
        ImGui::Text("Hello from aobut window!");
        if (ImGui::Button("Close Me"))
            show_help_about_item = false;
        ImGui::End();
    }
}
