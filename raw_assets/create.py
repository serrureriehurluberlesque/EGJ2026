from PIL import Image, ImageDraw

width = 480
height = 480
radius = 220
center = (width // 2, height // 2)

# Créer une image RGBA avec fond transparent
img = Image.new("RGBA", (width, height), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)

# Dessiner des cercles concentriques avec opacité décroissante
for r in range(radius, 0, -1):
    # L'opacité diminue linéairement du centre (255) vers le bord (0)
    alpha = int(255 * (1 - r / radius) ** 2)
    draw.ellipse(
        [center[0] - r, center[1] - r, center[0] + r, center[1] + r],
        fill=(255, 255, 255, alpha)
    )

img.save("light.png")
print("Image sauvegardée : light.png")
