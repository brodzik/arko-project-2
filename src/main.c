#include <SDL2/SDL.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define WIDTH 1000
#define HEIGHT 500

void lissajous(unsigned char *buffer, int width, int height, double a, double b, double delta);

void clear(SDL_Renderer *renderer)
{
    SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
    SDL_RenderClear(renderer);
}

void draw(unsigned char *buffer, SDL_Renderer *renderer)
{
    SDL_SetRenderDrawColor(renderer, 255, 0, 0, 255);

    for (int i = 0; i < HEIGHT; ++i)
    {
        for (int j = 0; j < WIDTH; ++j)
        {
            if (buffer[i * WIDTH + j])
            {
                SDL_RenderDrawPoint(renderer, j, i);
            }
        }
    }
}

void redraw(unsigned char *buffer, int width, int height, double a, double b, double delta, SDL_Renderer *renderer)
{
    memset(buffer, 0, WIDTH * HEIGHT);
    lissajous(buffer, width, height, a, b, delta);
    clear(renderer);
    draw(buffer, renderer);
    SDL_RenderPresent(renderer);
}

int main(int argc, char *argv[])
{
    SDL_Event event;
    SDL_Renderer *renderer;
    SDL_Window *window;

    SDL_Init(SDL_INIT_VIDEO);
    SDL_CreateWindowAndRenderer(WIDTH, HEIGHT, 0, &window, &renderer);

    unsigned char buffer[WIDTH * HEIGHT];

    int width = WIDTH;
    int height = HEIGHT;
    double a = 1;
    double b = 1;
    double delta = M_PI / 2;

    redraw(buffer, width, height, a, b, delta, renderer);

    while (1)
    {
        if (SDL_PollEvent(&event))
        {
            if (event.type == SDL_QUIT)
            {
                break;
            }
            else if (event.type == SDL_KEYDOWN)
            {
                switch (event.key.keysym.sym)
                {
                    case 'q':
                        a += 0.1;
                        redraw(buffer, width, height, a, b, delta, renderer);
                        break;

                    case 'a':
                        a -= 0.1;
                        redraw(buffer, width, height, a, b, delta, renderer);
                        break;

                    case 'w':
                        b += 0.1;
                        redraw(buffer, width, height, a, b, delta, renderer);
                        break;

                    case 's':
                        b -= 0.1;
                        redraw(buffer, width, height, a, b, delta, renderer);
                        break;

                    case 'e':
                        delta += 0.1;
                        redraw(buffer, width, height, a, b, delta, renderer);
                        break;

                    case 'd':
                        delta -= 0.1;
                        redraw(buffer, width, height, a, b, delta, renderer);
                        break;

                    default:
                        break;
                }
            }
        }
    }

    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();

    return 0;
}
