#!/usr/bin/env python3
# This code was taken from the official Flipper Zero firmware repository:
# https://github.com/flipperdevices/flipperzero-firmware
# And distributes under GNU GPL-3.0 license
import io
import os
import argparse
from PIL import Image, ImageOps

ICONS_SUPPORTED_FORMATS = ["png"]

ICONS_TEMPLATE_INC_ICON_NAME = ".global {name}\n"

ICONS_TEMPLATE_ASM_HEADER = ".section .rodata\n\n"
ICONS_TEMPLATE_ASM_ICON = """{name}:
    {name}_width: .byte {width}
    {name}_height: .byte {height}
    {name}_data: .byte {data}
"""
ICONS_TEMPLATE_ASM_ARR_HEADER = "{name}_arr:\n"
ICONS_TEMPLATE_ASM_ARR_LINE = "    .word {data}\n"


class CImage:
    def __init__(self, width: int, height: int, data: bytes):
        self.width = width
        self.height = height
        self.data = data

    def write(self, filename):
        with open(filename, "wb") as file:
            file.write(self.data)

    def data_as_carray(self):
        return ", ".join("0x{:02x}".format(img_byte) for img_byte in self.data)


def is_file_an_icon(filename):
    extension = filename.lower().split(".")[-1]
    return extension in ICONS_SUPPORTED_FORMATS


def png2xbm(file):
    with Image.open(file) as im:
        with io.BytesIO() as output:
            bw = im.convert("1")
            bw = ImageOps.invert(bw)
            bw.save(output, format="XBM")
            return output.getvalue()


def file2image(file):
    output = png2xbm(file)
    assert output
    f = io.StringIO(output.decode().strip())
    width = int(f.readline().strip().split(" ")[2])
    height = int(f.readline().strip().split(" ")[2])
    data = f.read().strip().replace("\n", "").replace(" ", "").split("=")[1][:-1]
    data_str = data[1:-1].replace(",", " ").replace("0x", "")
    data_bin = bytearray.fromhex(data_str)
    data = b"\x00" + data_bin
    return CImage(width, height, data)


def _icon2header(file):
    image = file2image(file)
    return image.width, image.height, image.data_as_carray()


def _iconIsSupported(filename):
    extension = filename.lower().split(".")[-1]
    return extension in ICONS_SUPPORTED_FORMATS


def icons(args):
    print("ICON: Converting icons")
    icons_c = open(
        os.path.join(args.output_directory, f"{args.filename}.s"),
        "w",
        newline="\n",
    )
    icons = []
    font_icons = []
    fonts = []
    icons_c.write(ICONS_TEMPLATE_ASM_HEADER)
    # Traverse icons tree, append image data to source file
    for dirpath, dirnames, filenames in os.walk(args.input_directory):
        print(f"ICON: Processing directory {dirpath}")
        dirnames.sort()
        filenames.sort()
        if not filenames:
            continue
        if os.path.basename(dirpath).startswith("font_"):
            print(f"ICON: Folder contains font")
            font_name = os.path.split(dirpath)[1].replace("-", "_")
            fonts.append(font_name)
            for filename in sorted(
                filenames, key=lambda current: int(current.split(".png")[0])
            ):
                fullfilename = os.path.join(dirpath, filename)
                if not _iconIsSupported(filename):
                    continue
                char_code = filename.split(".png")[0]
                char_name = f"{font_name}_{char_code}"
                print(f"ICON: Processing {font_name} character {chr(int(char_code))}")
                fullfilename = os.path.join(dirpath, filename)
                width, height, data = _icon2header(fullfilename)
                icons_c.write(
                    ICONS_TEMPLATE_ASM_ICON.format(
                        name=char_name, width=width, height=height, data=data
                    )
                )
                icons_c.write("\n")
                font_icons.append((char_name, width, height, 0, 1))
        else:
            # process icons
            for filename in filenames:
                if not _iconIsSupported(filename):
                    continue
                print(f"ICON: Processing icon {filename}")
                icon_name = "I_" + "_".join(filename.split(".")[:-1]).replace("-", "_")
                fullfilename = os.path.join(dirpath, filename)
                width, height, data = _icon2header(fullfilename)
                frame_name = f"_{icon_name}_0"
                icons_c.write(ICONS_TEMPLATE_C_FRAME.format(name=frame_name, data=data))
                icons_c.write(
                    ICONS_TEMPLATE_C_DATA.format(
                        name=f"_{icon_name}", data=f"{{{frame_name}}}"
                    )
                )
                icons_c.write("\n")
                icons.append((icon_name, width, height, 0, 1))
    print(f"ICON: Finalizing source file")
    icons_c.write(ICONS_TEMPLATE_ASM_ARR_HEADER.format(name=font_name))
    for name, width, height, frame_rate, frame_count in font_icons:
        icons_c.write(ICONS_TEMPLATE_ASM_ARR_LINE.format(data=name))

    icons_c.close()

    # Create Public Header
    print(f"ICON: Creating header")
    icons_h = open(
        os.path.join(args.output_directory, f"{args.filename}.inc"),
        "w",
        newline="\n",
    )
    for name, width, height, frame_rate, frame_count in icons:
        icons_h.write(ICONS_TEMPLATE_INC_ICON_NAME.format(name=name))
    for name in fonts:
        icons_h.write(ICONS_TEMPLATE_INC_ICON_NAME.format(name=name))
    icons_h.close()
    print(f"ICON: Done")
    return 0


def main():
    parser = argparse.ArgumentParser(description="Converting .png icons to asm array")
    parser.add_argument("input_directory", help="Source directory")
    parser.add_argument("output_directory", help="Output directory")
    parser.add_argument(
        "--filename",
        help="Base filename for file with icon data",
        required=False,
        default="assets_icons",
    )
    args = parser.parse_args()
    icons(args)


if __name__ == "__main__":
    main()
