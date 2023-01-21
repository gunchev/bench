/*/true;A="$(readlink -f -- "$0")";g++ --std=c++20 -O3 -Wall -Wextra -lbenchmark -o "$A.bin" "$A"&&"$A.bin" "$@";E=$?;rm "$A.bin";exit $E #*/
#include <algorithm>
#include <benchmark/benchmark.h>
#include <string>
#include <sysexits.h>


const char* data = "Hello world, to be or not to be a long string, that is the question!";

static void algorithm_lowercase_my(benchmark::State& state) {
    for (auto _ : state) {  // Code inside this loop is measured repeatedly
        std::string name = data;
        std::transform(name.cbegin(), name.cend(), name.begin(), [](char c) noexcept {
            return (c >= 'a' && c <= 'z') ? c = c - 'a' + 'A' : c;
        });
        benchmark::DoNotOptimize(name);  // Make sure the variable is not optimized away by compiler
    }
}
BENCHMARK(algorithm_lowercase_my);  // Register the function as a benchmark

static void loop_lowercase_my(benchmark::State& state) {
    for (auto _ : state) {  // Code before the loop is not measured
        std::string name = data;
        for (char& c : name) {
            if (c >= 'a' && c <= 'z') {
                c = c - 'a' + 'A';
            }
        }
        benchmark::DoNotOptimize(name);  // Make sure the variable is not optimized away by compiler
    }
}
BENCHMARK(loop_lowercase_my);  // Register the function as a benchmark


static void algorithm_lowercase_toupper(benchmark::State& state) {
    for (auto _ : state) {  // Code inside this loop is measured repeatedly
        std::string name = data;
        std::transform(name.cbegin(), name.cend(), name.begin(), [](char c) noexcept {
            return std::toupper(static_cast<unsigned char>(c));
        });
        benchmark::DoNotOptimize(name);  // Make sure the variable is not optimized away by compiler
    }
}
BENCHMARK(algorithm_lowercase_toupper);  // Register the function as a benchmark


int main(int argc, char** argv) {
    benchmark::Initialize(&argc, argv);
    if (benchmark::ReportUnrecognizedArguments(argc, argv)) {
        return EX_USAGE;
    }

    benchmark::RunSpecifiedBenchmarks();
    return EX_OK;
}
