import Foundation
import AdventOfCode
import XCTest

final class AoC_2021_Tests: XCTestCase {
    func test_day1_intro() async throws {
        let problem = AoC_2021_Day1("""
        199
        200
        208
        210
        200
        207
        240
        269
        260
        263
        """)
        let part1 = try await problem.solvePart1_functional()
        XCTAssertEqual(part1, 7)
        let part2 = try await problem.solvePart2_functional()
        XCTAssertEqual(part2, 5)
    }

    func test_day1() async throws {
        let problem = try AoC_2021_Day1(Resources.url(for: "2021_day1"))

        var answer = 1448
        var result = try await problem.solvePart1_imperative()
        XCTAssertEqual(result, answer)
        result = try await problem.solvePart1_functional()
        XCTAssertEqual(result, answer)
        result = try await problem.solvePart1_lazy()
        XCTAssertEqual(result, answer)
        print("Day1 / Part1 solution: \(answer)")

        answer = 1471
        result = try await problem.solvePart2_imperative()
        XCTAssertEqual(result, answer)
        result = try await problem.solvePart2_functional()
        XCTAssertEqual(result, answer)
        result = try await problem.solvePart2_lazy()
        XCTAssertEqual(result, answer)
        print("Day1 / Part2 solution: \(answer)")
    }

    func test_day2_intro() async throws {
        let problem = AoC_2021_Day2("""
        forward 5
        down 5
        forward 8
        up 3
        down 8
        forward 2
        """)
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 150)
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 900)
    }

    func test_day2() async throws {
        let problem = try AoC_2021_Day2(Resources.url(for: "2021_day2"))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 2187380)
        print("Day2 / Part1 solution: \(part1)")
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 2086357770)
        print("Day2 / Part2 solution: \(part2)")
    }

    func test_day3_intro() async throws {
        let problem = AoC_2021_Day3("""
        00100
        11110
        10110
        10111
        10101
        01111
        00111
        11100
        10000
        11001
        00010
        01010
        """)
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 198)
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 230)
    }

    func test_day3() async throws {
        let problem = try AoC_2021_Day3(Resources.url(for: "2021_day3"))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 3277364)
        print("Day3 / Part1 solution: \(part1)")
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 5736383)
        print("Day3 / Part2 solution: \(part2)")
    }

    func test_day4_intro() async throws {
        let problem = AoC_2021_Day4("""
        7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

        22 13 17 11 0
        8 2 23 4 24
        21 9 14 16 7
        6 10 3 18 5
        1 12 20 15 19

        3 15 0 2 22
        9 18 13 17 5
        19 8 7 25 23
        20 11 10 24 4
        14 21 16 12 6

        14 21 17 24 4
        10 16 15 9 19
        18 8 23 26 20
        22 11 13 6 5
        2 0 12 3 7
        """)
        let part1 = try problem.solvePart1()
        XCTAssertEqual(part1, 4512)
        let part2 = try problem.solvePart2()
        XCTAssertEqual(part2, 1924)
    }

    func test_day4() throws {
        let problem = try AoC_2021_Day4(Resources.url(for: "2021_day4"))
        let part1 = try problem.solvePart1()
        XCTAssertEqual(part1, 11536)
        print("Day4 / Part1 solution: \(part1)")
        let part2 = try problem.solvePart2()
        XCTAssertEqual(part2, 1284)
        print("Day4 / Part2 solution: \(part2)")
    }

    func test_day5_intro() async throws {
        let problem = AoC_2021_Day5("""
        0,9 -> 5,9
        8,0 -> 0,8
        9,4 -> 3,4
        2,2 -> 2,1
        7,0 -> 7,4
        6,4 -> 2,0
        0,9 -> 2,9
        3,4 -> 1,4
        0,0 -> 8,8
        5,5 -> 8,2
        """)
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 5)
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 12)
    }

    func test_day5() async throws {
        let problem = try AoC_2021_Day5(Resources.url(for: "2021_day5"))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 7380)
        print("Day5 / Part1 solution: \(part1)")
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 21373)
        print("Day5 / Part2 solution: \(part2)")
    }

    func test_day6_intro() {
        let problem = AoC_2021_Day6("3,4,3,1,2")
        XCTAssertEqual(problem.solvePart1(), 5934)
        XCTAssertEqual(problem.solvePart2(), 26984457539)
    }

    func test_day6() throws {
        let problem = try AoC_2021_Day6(Resources.url(for: "2021_day6"))
        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 352195)
        print("Day6 / Part1 solution: \(part1)")
        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 1600306001288)
        print("Day6 / Part2 solution: \(part2)")
    }

    func test_day7_intro() {
        let problem = AoC_2021_Day7("16,1,2,0,4,2,7,1,2,14")
        XCTAssertEqual(problem.solvePart1(), 37)
        XCTAssertEqual(problem.solvePart2(), 168)
    }

    func test_day7() throws {
        let problem = try AoC_2021_Day7(Resources.url(for: "2021_day7"))
        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 336131)
        print("Day7 / Part1 solution: \(part1)")
        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 92676646)
        print("Day7 / Part2 solution: \(part2)")
    }

    func test_day8_intro() async throws {
        let problem = AoC_2021_Day8("""
        be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
        edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
        fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
        fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
        aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
        fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
        dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
        bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
        egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
        gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
        """)
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 26)
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 61229)
    }

    func test_day8() async throws {
        let problem = try AoC_2021_Day8(Resources.url(for: "2021_day8"))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 303)
        print("Day8 / Part1 solution: \(part1)")
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 961734)
        print("Day8 / Part2 solution: \(part2)")
    }

    func test_day9_intro() async throws {
        let problem = AoC_2021_Day9("""
        2199943210
        3987894921
        9856789892
        8767896789
        9899965678
        """)
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 15)
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 1134)
    }

    func test_day9() async throws {
        let problem = try AoC_2021_Day9(Resources.url(for: "2021_day9"))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 508)
        print("Day9 / Part1 solution: \(part1)")
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 1564640)
        print("Day9 / Part2 solution: \(part2)")
    }

    func test_day10_intro() async throws {
        let problem = AoC_2021_Day10("""
        [({(<(())[]>[[{[]{<()<>>
        [(()[<>])]({[<{<<[]>>(
        {([(<{}[<>[]}>{[]{[(<()>
        (((({<>}<{<{<>}{[]{[]{}
        [[<[([]))<([[{}[[()]]]
        [{[{({}]{}}([{[{{{}}([]
        {<[[]]>}<{[{[{[]{()[[[]
        [<(<(<(<{}))><([]([]()
        <{([([[(<>()){}]>(<<{{
        <{([{{}}[<[[[<>{}]]]>[]]
        """)
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 26397)
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 288957)
    }

    func test_day10() async throws {
        let problem = try AoC_2021_Day10(Resources.url(for: "2021_day10"))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 268845)
        print("Day10 / Part1 solution: \(part1)")
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 4038824534)
        print("Day10 / Part2 solution: \(part2)")
    }

    func test_day11_intro() {
        let problem = AoC_2021_Day11("""
        5483143223
        2745854711
        5264556173
        6141336146
        6357385478
        4167524645
        2176841721
        6882881134
        4846848554
        5283751526
        """)
        XCTAssertEqual(problem.solvePart1(), 1656)
        XCTAssertEqual(problem.solvePart2(), 195)
    }

    func test_day11_intro_steps() {
        let problem = AoC_2021_Day11("""
        5483143223
        2745854711
        5264556173
        6141336146
        6357385478
        4167524645
        2176841721
        6882881134
        4846848554
        5283751526
        """)
        XCTAssertEqual(problem.iterations { $0.count == 1 }.levels, """
        6594254334
        3856965822
        6375667284
        7252447257
        7468496589
        5278635756
        3287952832
        7993992245
        5957959665
        6394862637
        """)
        XCTAssertEqual(problem.iterations { $0.count == 10 }.levels, """
        0481112976
        0031112009
        0041112504
        0081111406
        0099111306
        0093511233
        0442361130
        5532252350
        0532250600
        0032240000
        """)
        XCTAssertEqual(problem.iterations { $0.count == 100 }.levels, """
        0397666866
        0749766918
        0053976933
        0004297822
        0004229892
        0053222877
        0532222966
        9322228966
        7922286866
        6789998766
        """)
        XCTAssertEqual(problem.iterations { $0.count == 195 }.levels, """
        0000000000
        0000000000
        0000000000
        0000000000
        0000000000
        0000000000
        0000000000
        0000000000
        0000000000
        0000000000
        """)
    }

    func test_day11() throws {
        let problem = try AoC_2021_Day11(Resources.url(for: "2021_day11"))
        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 1683)
        print("Day11 / Part1 solution: \(part1)")
        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 788)
        print("Day11 / Part2 solution: \(part2)")
    }

    func test_day12_intro1() {
        let problem = AoC_2021_Day12("""
        start-A
        start-b
        A-c
        A-b
        b-d
        A-end
        b-end
        """)
        XCTAssertEqual(problem.solvePart1(), 10)
        XCTAssertEqual(problem.solvePart2(), 36)
    }

    func test_day12_intro2() {
        let problem = AoC_2021_Day12("""
        dc-end
        HN-start
        start-kj
        dc-start
        dc-HN
        LN-dc
        HN-end
        kj-sa
        kj-HN
        kj-dc
        """)
        XCTAssertEqual(problem.solvePart1(), 19)
        XCTAssertEqual(problem.solvePart2(), 103)
    }


    func test_day12_intro3() {
        let problem = AoC_2021_Day12("""
        fs-end
        he-DX
        fs-he
        start-DX
        pj-DX
        end-zg
        zg-sl
        zg-pj
        pj-he
        RW-he
        fs-DX
        pj-RW
        zg-RW
        start-pj
        he-WI
        zg-he
        pj-fs
        start-RW
        """)
        XCTAssertEqual(problem.solvePart1(), 226)
        XCTAssertEqual(problem.solvePart2(), 3509)
    }

    func test_day12() throws {
        let problem = try AoC_2021_Day12(Resources.url(for: "2021_day12"))
        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 3761)
        print("Day12 / Part1 solution: \(part1)")
        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 99138)
        print("Day12 / Part2 solution: \(part2)")
    }

    func test_day13_intro() {
        let problem = AoC_2021_Day13("""
        6,10
        0,14
        9,10
        0,3
        10,4
        4,11
        6,0
        6,12
        4,1
        0,13
        10,12
        3,4
        3,0
        8,4
        1,10
        2,14
        8,10
        9,0

        fold along y=7
        fold along x=5
        """)
        XCTAssertEqual(problem.solvePart1(), 17)
    }

    func test_day13() throws {
        let problem = try AoC_2021_Day13(Resources.url(for: "2021_day13"))
        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 729)
        print("Day13 / Part1 solution: \(part1)")
        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, "RGZLBHFP")
        print("Day13 / Part2 solution: \(part2)")
    }

    func test_day14_intro() {
        let problem = AoC_2021_Day14("""
        NNCB

        CH -> B
        HH -> N
        CB -> H
        NH -> C
        HB -> C
        HC -> B
        HN -> C
        NN -> C
        BH -> H
        NC -> B
        NB -> B
        BN -> B
        BB -> N
        BC -> B
        CC -> N
        CN -> C
        """)
        XCTAssertEqual(problem.solvePart1(), 1588)
        XCTAssertEqual(problem.solvePart2(), 2188189693529)
    }

    func test_day14() throws {
        let problem = try AoC_2021_Day14(Resources.url(for: "2021_day14"))
        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 4517)
        print("Day14 / Part1 solution: \(part1)")
        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 4704817645083)
        print("Day14 / Part2 solution: \(part2)")
    }

    func test_day15_intro() {
        let problem = AoC_2021_Day15("""
        1163751742
        1381373672
        2136511328
        3694931569
        7463417111
        1319128137
        1359912421
        3125421639
        1293138521
        2311944581
        """)
        XCTAssertEqual(problem.solvePart1(), 40)
        XCTAssertEqual(problem.solvePart2(), 315)
    }

    func test_day15() throws {
        let problem = try AoC_2021_Day15(Resources.url(for: "2021_day15"))
        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 415)
        print("Day15 / Part1 solution: \(part1)")
        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 2864)
        print("Day15 / Part2 solution: \(part2)")
    }

    func test_day16_intro() {
        let part1: (String) -> Int = { AoC_2021_Day16($0).solvePart1() }
        XCTAssertEqual(part1("D2FE28"), 6)
        XCTAssertEqual(part1("38006F45291200"), 9)
        XCTAssertEqual(part1("EE00D40C823060"), 14)
        XCTAssertEqual(part1("8A004A801A8002F478"), 16)
        XCTAssertEqual(part1("620080001611562C8802118E34"), 12)
        XCTAssertEqual(part1("C0015000016115A2E0802F182340"), 23)
        XCTAssertEqual(part1("A0016C880162017C3686B18A3D4780"), 31)

        let part2: (String) -> Int = { AoC_2021_Day16($0).solvePart2() }
        XCTAssertEqual(part2("C200B40A82"), 3)
        XCTAssertEqual(part2("04005AC33890"), 54)
        XCTAssertEqual(part2("880086C3E88112"), 7)
        XCTAssertEqual(part2("CE00C43D881120"), 9)
        XCTAssertEqual(part2("D8005AC2A8F0"), 1)
        XCTAssertEqual(part2("F600BC2D8F"), 0)
        XCTAssertEqual(part2("9C005AC2F8F0"), 0)
        XCTAssertEqual(part2("9C0141080250320F1802104A08"), 1)
    }

    func test_day16() throws {
        let problem = try AoC_2021_Day16(Resources.url(for: "2021_day16"))
        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 1007)
        print("Day16 / Part1 solution: \(part1)")
        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 834151779165)
        print("Day16 / Part2 solution: \(part2)")
    }

    func test_day17_intro() {
        let problem = AoC_2021_Day17("target area: x=20..30, y=-10..-5")
        XCTAssertEqual(problem.solvePart1(), 45)
        XCTAssertEqual(problem.solvePart2(), 112)
    }

    func test_day17() throws {
        let problem = try AoC_2021_Day17(Resources.url(for: "2021_day17"))
        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 35511)
        print("Day17 / Part1 solution: \(part1)")
        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 3282)
        print("Day17 / Part2 solution: \(part2)")
    }

    func test_day18_intro() async throws {
        let problem = AoC_2021_Day18("""
        [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
        [[[5,[2,8]],4],[5,[[9,9],0]]]
        [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
        [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
        [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
        [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
        [[[[5,4],[7,7]],8],[[8,3],8]]
        [[9,3],[[9,9],[6,[4,9]]]]
        [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
        [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
        """)
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 4140)
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 3993)
    }

    func test_day18() async throws {
        let problem = try AoC_2021_Day18(Resources.url(for: "2021_day18"))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 4641)
        print("Day18 / Part1 solution: \(part1)")
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 4624)
        print("Day18 / Part2 solution: \(part2)")
    }

    func test_day19_intro() async throws {
        let problem = AoC_2021_Day19("""
        --- scanner 0 ---
        404,-588,-901
        528,-643,409
        -838,591,734
        390,-675,-793
        -537,-823,-458
        -485,-357,347
        -345,-311,381
        -661,-816,-575
        -876,649,763
        -618,-824,-621
        553,345,-567
        474,580,667
        -447,-329,318
        -584,868,-557
        544,-627,-890
        564,392,-477
        455,729,728
        -892,524,684
        -689,845,-530
        423,-701,434
        7,-33,-71
        630,319,-379
        443,580,662
        -789,900,-551
        459,-707,401

        --- scanner 1 ---
        686,422,578
        605,423,415
        515,917,-361
        -336,658,858
        95,138,22
        -476,619,847
        -340,-569,-846
        567,-361,727
        -460,603,-452
        669,-402,600
        729,430,532
        -500,-761,534
        -322,571,750
        -466,-666,-811
        -429,-592,574
        -355,545,-477
        703,-491,-529
        -328,-685,520
        413,935,-424
        -391,539,-444
        586,-435,557
        -364,-763,-893
        807,-499,-711
        755,-354,-619
        553,889,-390

        --- scanner 2 ---
        649,640,665
        682,-795,504
        -784,533,-524
        -644,584,-595
        -588,-843,648
        -30,6,44
        -674,560,763
        500,723,-460
        609,671,-379
        -555,-800,653
        -675,-892,-343
        697,-426,-610
        578,704,681
        493,664,-388
        -671,-858,530
        -667,343,800
        571,-461,-707
        -138,-166,112
        -889,563,-600
        646,-828,498
        640,759,510
        -630,509,768
        -681,-892,-333
        673,-379,-804
        -742,-814,-386
        577,-820,562

        --- scanner 3 ---
        -589,542,597
        605,-692,669
        -500,565,-823
        -660,373,557
        -458,-679,-417
        -488,449,543
        -626,468,-788
        338,-750,-386
        528,-832,-391
        562,-778,733
        -938,-730,414
        543,643,-506
        -524,371,-870
        407,773,750
        -104,29,83
        378,-903,-323
        -778,-728,485
        426,699,580
        -438,-605,-362
        -469,-447,-387
        509,732,623
        647,635,-688
        -868,-804,481
        614,-800,639
        595,780,-596

        --- scanner 4 ---
        727,592,562
        -293,-554,779
        441,611,-461
        -714,465,-776
        -743,427,-804
        -660,-479,-426
        832,-632,460
        927,-485,-438
        408,393,-506
        466,436,-512
        110,16,151
        -258,-428,682
        -393,719,612
        -211,-452,876
        808,-476,-593
        -575,615,604
        -485,667,467
        -680,325,-822
        -627,-443,-432
        872,-547,-609
        833,512,582
        807,604,487
        839,-516,451
        891,-625,532
        -652,-548,-490
        30,-46,-14
        """)
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 79)
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 3621)
    }

    func test_day19() async throws {
        let problem = try AoC_2021_Day19(Resources.url(for: "2021_day19"))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 467)
        print("Day19 / Part1 solution: \(part1)")
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 12226)
        print("Day19 / Part2 solution: \(part2)")
    }
}
