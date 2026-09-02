> ## Why this fork exists
>
> This is a fork of [mlalma/MisakiSwift](https://github.com/mlalma/MisakiSwift)
> with **one line changed**, so that Kokoro's G2P can run in the same Swift
> package graph as a model that needs a newer MLX.
>
> ```diff
> - .package(url: ".../mlx-swift", exact: "0.30.2"),
> + .package(url: ".../mlx-swift", from: "0.30.2"),
> ```
>
> Upstream pins `mlx-swift` to **exactly 0.30.2**. `mlx-swift-lm` (used for
> on-device language models) requires **0.31.3..<0.32.0**, so SwiftPM refuses
> any graph containing both. Relaxing the pin in
> [kokoro-ios](https://github.com/NooronSpatial/kokoro-ios) alone is not
> enough — this package carries the same pin, so the G2P drags it in on its
> own.
>
> The relaxed range was verified before this fork was made: MisakiSwift builds
> against **mlx-swift 0.31.6 with zero errors and zero warnings**, with the
> pin as the only variable changed. Compilation is not proof of numerical
> equivalence, and runtime behaviour on device is checked separately.
>
> Nothing else is modified. Fixes belong upstream; if upstream relaxes the
> pin, this fork should be deleted rather than maintained.
>
> ---
>
# MisakiSwift

A Swift port of the [Misaki](https://github.com/hexgrad/misaki) grapheme-to-phoneme (G2P) library for converting English text to phonetic representations suitable for text-to-speech (TTS) engines.

## Supported Platforms

- iOS 18.0+
- macOS 15.0+
- (Other Apple platforms may work as well)

## Installation

Add MisakiSwift to your Swift Package Manager dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/mlalma/MisakiSwift", from: "1.0.1")
]
```

## Basic Usage

```swift
import MisakiSwift

// Create G2P converter (british = false for American English)
let g2p = EnglishG2P(british: false)

// Convert text to phonemes
let (phonemes, tokens) = g2p.phonemize(text: "Hello world!")
print(phonemes) // "həlˈO wˈɜɹld!"
```

## Custom Phoneme Override

Use Markdown-like syntax to specify exact pronunciations in case you don't want to use fallback network:

```swift
let g2p = EnglishG2P(british: false)
let text = "[Misaki](/misˈɑki/) is a G2P engine designed for [Kokoro](/kˈOkəɹO/) models."
let (phonemes, _) = g2p.phonemize(text: text)
// "misˈɑki ɪz ɐ ʤˈitəpˈi ˈɛnʤən dəzˈInd fɔɹ kˈOkəɹO mˈɑdᵊlz."
```

## Overview

MisakiSwift is a high-quality English G2P conversion library that transforms written text into phonemes using both dictionary-based lookup and neural network fallback. It supports British and American English pronunciations and includes advanced features like stress pattern handling and custom phoneme overrides.

## Key Features

- **High Accuracy**: Combines extensive pronunciation dictionaries with neural network fallback for out-of-vocabulary words
- **Dual Dialect Support**: Supports both British and American English pronunciations
- **Advanced Text Processing**: Handles punctuation, numbers, acronyms, and complex formatting
- **Custom Phoneme Override**: Use Markdown-like syntax to specify exact pronunciations: `[word](/phonemes/)`
- **Stress Pattern Control**: Automatic stress assignment with manual override capabilities
- **Apple Ecosystem Integration**: Uses Apple's Natural Language framework instead of external dependencies like SpaCy

## Architecture

MisakiSwift consists of several key components:

- **`EnglishG2P`**: Main conversion pipeline that orchestrates tokenization, lexicon lookup, and neural network fallback
- **`Lexicon`**: Dictionary-based pronunciation lookup using gold and silver dictionaries
- **`EnglishFallbackNetwork`**: Transformer-based model (ported to run on MLX) for phoneme prediction for out-of-vocabulary words

## Key Differences from Python Misaki

1. **POS Tagging**: Uses Apple's `NaturalLanguage` framework instead of SpaCy for part-of-speech tagging
2. **Neural Network**: The BART-based fallback network is ported to run on [MLX](https://github.com/ml-explore/mlx-swift)
3. **Resource Management**: All model weights and dictionaries are bundled as resources within the Swift package

## Dependencies

- **[MLX](https://github.com/ml-explore/mlx-swift)**: Machine learning framework for the neural network component
- **NaturalLanguage**: Apple's built-in framework for text processing and POS tagging
- **MLXUtilsLibrary**: For `MToken`, used also in other parts of the ML stack

## Model Resources

The package includes pre-trained models and dictionaries:

- **BART Model Weights**: Neural network weights for phoneme prediction (US and GB variants)
- **Gold Dictionary**: High-confidence pronunciation mappings
- **Silver Dictionary**: Additional pronunciation mappings with slightly lower confidence

These resources are automatically bundled with the package and loaded at runtime.
