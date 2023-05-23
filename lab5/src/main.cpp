#include <iostream>
#include <string>
#include <string_view>

static constexpr size_t kMaxLength = 255;
static constexpr std::string_view kInvalidInput = "Invalid input";

extern "C" {
    const char* count_words(const char* input, size_t size);
}

int main() {
    std::cout << "Input line of text with <= 255 characters" << std::endl;

    std::string input;
    std::getline(std::cin, input);

    if (input.size() > kMaxLength) {
        std::cout << "Input should be <= 255 characters long" << std::endl;
        return -1;
    }

    input = count_words(input.c_str(), input.size());
    std::cout << input << std::endl;
    return 0;
}