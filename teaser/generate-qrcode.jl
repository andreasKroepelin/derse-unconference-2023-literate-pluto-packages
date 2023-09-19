using QRCoders, PNGFiles, Colors

PNGFiles.save(
    "qr-code.png",
    ifelse.(
        qrcode("https://github.com/andreasKroepelin/derse-unconference-2023-literate-pluto-packages"),
        colorant"#8839efff",
        colorant"#fff0"
    )
)
