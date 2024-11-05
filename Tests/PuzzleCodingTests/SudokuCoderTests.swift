import Testing
@testable import PuzzleCoding
import Foundation

struct SudokuCoderTests {
    typealias Version = Sudoku.Version
    private static var legacyVersions: [Version] { [.clue, .noNakedSingles] }
    private static var modernVersions: [Version] { Version.allCases.filter { !legacyVersions.contains($0) }}

    private var sampleContent: [CellContent?] {
        "000105000140000670080002400063070010900000003010090520007200080026000035000409000".map {
            let number = $0.wholeNumberValue!
            return if number == 0 {
                switch (0...2).randomElement()! {
                case 0: .solution((1...9).randomElement()!)
                case 1: .candidates(Set((1...9).randomSample(count: (1...9).randomElement()!)))
                default: nil
                }
            } else {
                .clue(number)
            }
        }
    }

    private var sampleGrid: Grid {
        var grid = Grid(size: .grid9x9)
        let content = sampleContent
        grid.indices.forEach { grid[$0] = content[$0] }
        return grid
    }

    @Test
    func clueRoundtrips() throws {
        let grid = sampleGrid
        let puzzle = Sudoku(grid: grid)
        let version = Sudoku.Version.clue
        let rawPuzzle = puzzle.encode(using: version)
        let (puzzleFromRaw, versionFromRaw) = try #require(Sudoku.decode(rawPuzzle))

        #expect(versionFromRaw == version)
        let cleanGrid: [CellContent?] = grid.map {
            switch $0 {
            case nil, .clue: $0
            case .solution(let value): .clue(value)
            case .candidates: nil
            }
        }
        #expect(Array(puzzleFromRaw.grid) == cleanGrid)

        let puzzleCount = Double(rawPuzzle.count)

        print("""
            \(puzzle)
            \(rawPuzzle)
            puzzleCoding.count = \(puzzleCount.formatted(.number.precision(.fractionLength(0))))
            """)
    }

    @Test
    func shiftRoundtrips() throws {
        let grid = sampleGrid
        let puzzle = Sudoku(grid: grid)
        let version = Sudoku.Version.noNakedSingles
        let rawPuzzle = puzzle.encode(using: version)
        let (puzzleFromRaw, versionFromRaw) = try #require(Sudoku.decode(rawPuzzle))

        #expect(versionFromRaw == version)
        if !grid.contains(where: { $0?.candidates?.count == 1 }) {
            // known bug with this algorithm where a naked single comes back as a solved cell
            #expect(puzzleFromRaw.grid == grid)
        }
        let puzzleCount = Double(rawPuzzle.count)
        print("""
            \(puzzle)
            \(rawPuzzle)
            puzzleCoding.count = \(puzzleCount.formatted(.number.precision(.fractionLength(0))))
            """)
    }

    @Test(arguments: modernVersions)
    func coderRoundtrips(version: Version) async throws {
        let puzzle = Sudoku(grid: sampleGrid)

        let rawPuzzle = puzzle.encode(using: version)
        let decoded = try #require(Sudoku.decode(rawPuzzle))

        #expect(decoded.version == version)
        #expect(decoded.puzzle.grid == puzzle.grid)

        let puzzleCount = Double(rawPuzzle.count)
        print("""
            \(puzzle) \(version)
            \(rawPuzzle)
            puzzleCoding.count = \(puzzleCount.formatted(.number.precision(.fractionLength(0))))
            """)
    }

    @Test(arguments: PuzzleType.SudokuType.allCases)
    func sudokuTypeRoundTrips(_ type: PuzzleType.SudokuType) async throws {
        let grid = sampleGrid
        switch type {
        case .sudoku:
            let puzzle = Sudoku(grid: grid)
            let raw = puzzle.encode()
            let decoded = try #require(Sudoku.decode(raw))
            #expect(decoded.puzzle == puzzle)
        case .sudokuX:
            let puzzle = SudokuX(grid: grid)
            let raw = puzzle.encode()
            let decoded = try #require(SudokuX.decode(raw))
            #expect(decoded.puzzle == puzzle)
        case .windoku:
            let puzzle = Windoku(grid: grid)
            let raw = puzzle.encode()
            let decoded = try #require(Windoku.decode(raw))
            #expect(decoded.puzzle == puzzle)
        }
    }

    @Test
    func knownShiftCodingDecodes() throws {
        let rawEncoded = "0m4e4cog1121k084g41k544403o0ggs409208121g1400409020g10g4o4a4110hg6082240h4hc28g4g2400h2281410g03200980g411g409k04ggg201184840321868k8k410m10g109g6o61108o2g621410g"
        let content: [CellContent?] = [
            .candidates(Set([1, 2, 4])), .candidates(Set([1, 2, 3, 7])), .candidates(Set([2, 3, 7])), .candidates(Set([4, 8, 9])), .clue(5), .clue(6), .candidates(Set([7, 9])), .candidates(Set([2, 8])), .candidates(Set([2, 9])),
            .candidates(Set([2, 4, 5])), .candidates(Set([2, 5, 7])), .candidates(Set([2, 7])), .clue(1), .candidates(Set([8, 9])), .candidates(Set([4, 9])), .candidates(Set([2, 7, 8, 9])), .clue(3), .solution(6),
            .clue(8), .clue(6), .clue(9), .solution(7), .solution(2), .clue(3), .solution(1), .solution(4), .solution(5),
            .candidates(Set([2, 9])), .candidates(Set([2, 8, 9])), .candidates(Set([2, 6, 8])), .clue(5), .clue(4), .candidates(Set([1, 2, 9])), .solution(3), .candidates(Set([1, 6])), .solution(7),
            .candidates(Set([2, 5, 9])), .candidates(Set([2, 3, 5, 9])), .candidates(Set([3, 6])), .candidates(Set([2, 9])), .candidates(Set([1, 9])), .solution(7), .clue(4), .candidates(Set([1, 6])), .clue(8),
            .clue(7), .solution(4), .clue(1), .solution(6), .clue(3), .solution(8), .candidates(Set([2, 9])), .clue(5), .candidates(Set([2, 9])),
            .clue(3), .candidates(Set([7, 9])), .candidates(Set([4, 7])), .candidates(Set([4, 9])), .solution(6), .clue(5), .candidates(Set([2, 8])), .candidates(Set([2, 8])), .clue(1),
            .clue(6), .candidates(Set([1, 2, 8])), .candidates(Set([2, 4, 8])), .candidates(Set([2, 4, 8])), .clue(7), .candidates(Set([1, 2, 4])), .solution(5), .clue(9), .clue(3),
            .candidates(Set([1, 2, 9])), .candidates(Set([1, 2, 8, 9])), .clue(5), .solution(3), .candidates(Set([1, 8, 9])), .candidates(Set([1, 2, 9])), .clue(6), .clue(7), .solution(4)
        ]

        var expectedGrid = Grid(size: .grid9x9)
        expectedGrid.indices.forEach { expectedGrid[$0] = content[$0] }

        let decoded = try #require(Sudoku.decode(rawEncoded))
        #expect(decoded.puzzle.grid == expectedGrid)

        let encoded = Sudoku(grid: expectedGrid).encode(using: .noNakedSingles)
        #expect(encoded == rawEncoded)
    }
}

extension ClosedRange<Int> {
    func randomSample(count: Int) -> [Int] {
        Array(Array(self).shuffled().prefix(count))
    }
}

private extension CellContent {
    var candidates: Set<Int>? {
        if case .candidates(let candidates) = self { candidates } else { nil }
    }
}
