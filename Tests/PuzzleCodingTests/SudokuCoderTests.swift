import Testing
@testable import PuzzleCoding
import Foundation

private typealias Progress = PuzzleCoding.Progress

struct SudokuCoderTests {
    typealias Version = Sudoku.Version
    private static var legacyVersions: [Version] { [.clue] }
    private static var modernVersions: [Version] { Version.allCases.filter { !legacyVersions.contains($0) }}

    private var sampleCells: [Cell] {
        let clues: [Clue?] = "000105000140000670080002400063070010900000003010090520007200080026000035000409000".map(\.wholeNumberValue!).map { $0 == 0 ? nil : .solution($0) }
        return clues.map { clue in
            guard clue == nil else { return Cell(clue: clue) }
            let progress: Progress? = switch (0...2).randomElement()! {
            case 0: .guess((1...9).randomElement()!)
            case 1: .candidates(Set((1...9).randomSample(count: (1...9).randomElement()!)))
            default: nil
            }
            return Cell(progress: progress)
        }
    }

    @Test
    func clueRoundtrips() throws {
        let cells = sampleCells
        let version = Sudoku.Version.clue
        let puzzle = try #require(try Sudoku(cells: cells, version: version))
        let rawPuzzle = puzzle.rawValue
        let puzzleFromRaw = try #require(Sudoku(rawValue: rawPuzzle))

        #expect(puzzleFromRaw.version == version)
        let cleanCells: [Cell] = cells.map { cell in
            guard let content = cell.progress else { return cell }
            return switch content {
            case .guess(let value): Cell(clue: .solution(value))
            case .candidates: Cell()
            }
        }
        #expect(puzzleFromRaw.map(\.clue) == cleanCells.map(\.clue))

        let puzzleCount = Double(rawPuzzle.count)

        print("""
            \(puzzle)
            \(rawPuzzle)
            puzzleCoding.count = \(puzzleCount.formatted(.number.precision(.fractionLength(0))))
            """)
    }

    @Test(arguments: modernVersions)
    func coderRoundtrips(version: Version) async throws {
        let puzzle = try #require(try Sudoku(cells: sampleCells, version: version))

        let rawPuzzle = puzzle.rawValue
        let decoded = try #require(Sudoku(rawValue: rawPuzzle))

        #expect(decoded == puzzle)

        let puzzleCount = Double(rawPuzzle.count)
        print("""
            \(puzzle) \(version)
            \(rawPuzzle)
            puzzleCoding.count = \(puzzleCount.formatted(.number.precision(.fractionLength(0))))
            """)
    }

    @Test(arguments: [PuzzleType.sudoku, .sudokuX, .windoku])
    func sudokuTypeRoundTrips(_ type: PuzzleType) async throws {
        let cells = sampleCells
        switch type {
        case .sudoku:
            let puzzle = try #require(try Sudoku(cells: cells))
            let raw = puzzle.rawValue
            let decoded = try #require(Sudoku(rawValue: raw))
            #expect(decoded == puzzle)
        case .sudokuX:
            let puzzle = try #require(try SudokuX(cells: cells))
            let raw = puzzle.rawValue
            let decoded = try #require(SudokuX(rawValue: raw))
            #expect(decoded == puzzle)
        case .windoku:
            let puzzle = try #require(try Windoku(cells: cells))
            let raw = puzzle.rawValue
            let decoded = try #require(Windoku(rawValue: raw))
            #expect(decoded == puzzle)
        default: fatalError()
        }
    }
}

extension ClosedRange<Int> {
    func randomSample(count: Int) -> [Int] {
        Array(Array(self).shuffled().prefix(count))
    }
}

private extension Progress {
    var candidates: Set<Int>? {
        if case .candidates(let candidates) = self { candidates } else { nil }
    }
}
