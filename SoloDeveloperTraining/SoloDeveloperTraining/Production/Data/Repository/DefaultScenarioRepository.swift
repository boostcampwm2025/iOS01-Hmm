//
//  DefaultScenarioRepository.swift
//  SoloDeveloperTraining
//
//  Created by Gemini on 1/24/26.
//

import Foundation

final class DefaultScenarioRepository: ScenarioRepository {

    func fetchScenario(for career: Career) async throws -> Scenario? {
        return allScenarios.first { $0.career == career }
    }

    func fetchAllScenario() async throws -> [Scenario] {
        return allScenarios
    }

    func calculateEnding(
        evt01: ChoiceResult,
        evt02: ChoiceResult,
        evt03: ChoiceResult,
        evt04: ChoiceResult
    ) -> Ending {
        switch (evt01, evt02, evt03, evt04) {
        case (.optionA, .optionA, .optionA, .optionA):
            return Ending(id: "END-01", type: .aceDeveloper)
        case (.optionA, .optionA, .optionA, .optionB):
            return Ending(id: "END-02", type: .startupCEO)
        case (.optionA, .optionA, .optionB, .optionA):
            return Ending(id: "END-03", type: .techInfluencer)
        case (.optionA, .optionB, .optionA, .optionA):
            return Ending(id: "END-04", type: .geniusHacker)
        case (.optionA, .optionB, .optionA, .optionB):
            return Ending(id: "END-05", type: .startupCEO)
        case (.optionA, .optionB, .optionB, .optionA):
            return Ending(id: "END-06", type: .techInfluencer)
        case (.optionA, .optionA, .optionB, .optionB):
            return Ending(id: "END-07", type: .startupCEO)
        case (.optionA, .optionB, .optionB, .optionB):
            return Ending(id: "END-08", type: .digitalNomad)
        case (.optionB, .optionA, .optionA, .optionA):
            return Ending(id: "END-09", type: .geniusHacker)
        case (.optionB, .optionA, .optionA, .optionB):
            return Ending(id: "END-10", type: .darkWebAgent)
        case (.optionB, .optionA, .optionB, .optionA):
            return Ending(id: "END-11", type: .digitalNomad)
        case (.optionB, .optionA, .optionB, .optionB):
            return Ending(id: "END-12", type: .darkWebAgent)
        case (.optionB, .optionB, .optionA, .optionA):
            return Ending(id: "END-13", type: .aceDeveloper)
        case (.optionB, .optionB, .optionA, .optionB):
            return Ending(id: "END-14", type: .geniusHacker)
        case (.optionB, .optionB, .optionB, .optionA):
            return Ending(id: "END-15", type: .techInfluencer)
        case (.optionB, .optionB, .optionB, .optionB):
            return Ending(id: "END-16", type: .digitalNomad)
        }
    }

    func fetchRebirthStory() -> [ScenarioPage] {
        return [
            ScenarioPage(
                imageName: "rebirth_story_1",
                text: """
                내가 태어난 곳은
                문명과 거리가 먼 산촌한 항구리
                """,
                pageType: .story
            ),
            ScenarioPage(
                imageName: "rebirth_story_2",
                text: """
                특별한 것 없이 무난하게 성장해왔고,
                그냥 그러저럭 살아왔다.
                """,
                pageType: .story
            ),
            ScenarioPage(
                imageName: "rebirth_story_3",
                text: """
                그럭저럭 살다보니
                어느덧 대학교를 졸업했고
                """,
                pageType: .story
            ),
            ScenarioPage(
                imageName: "rebirth_story_4",
                text: """
                나는 그렇게...
                '백수'가 되었다.
                """,
                pageType: .story
            )
        ]
    }

    // MARK: - Hardcoded Data
    // TODO: 시나리오 텍스트, 이미지 수정
    private let allScenarios: [Scenario] = [
        Scenario(
            id: "career_백수",
            career: .unemployed,
            scenarioType: .normal,
            pages: [
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "졸업 후 +48d\n오늘 한 일: 이불 정리 (생략), 배달 앱 열기 (성공), 링크드인 프로필 사진 변경 (3시간 소요).",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "그리고... 알고리즘 추천 영상 6시간째 시청중\n\n\"비전공자 6개월만에 개발자 되는 법\"",
                    pageType: .story
                )
            ]
        ),
        Scenario(
            id: "career_노트북 보유자",
            career: .laptopOwner,
            scenarioType: .normal,
            pages: [
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "당근마켓에서 15만원짜리 중고 노트북을 샀다. 팬 소리가 비행기 이륙 수준이지만 괜찮다.",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "(노트북에 스티커를 잔뜩 붙인 후) 난 이제 개발자다.",
                    pageType: .story
                )
            ]
        ),
        Scenario(
            id: "career_개발자 지망생",
            career: .aspiringDeveloper,
            scenarioType: .normal,
            pages: [
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "print(\"Hello World\")\n엔터를 눌렀다.\n화면에 글자가 찍혔다.\n\"Hello World\"",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "이건 좀... 감동이잖아?",
                    pageType: .story
                )
            ]
        ),
        Scenario(
            id: "career_하찮은 개발자",
            career: .juniorDeveloper,
            scenarioType: .event,
            pages: [
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "\"저 사람 개발자 같다\"\n(카페에서 유튜브 보고 있음)\n나한테 하는 말인가?... 기분이 나쁜것 같기도, 좋은것 같기도...",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "띠링. 메일이 왔다. \"축하드립니다\"\n그런데 두 개의 메일이 기다리고 있다.\n뭘 열어보지...?",
                    pageType: .choice(Choice(optionA: "모 기업 최종 합격 메일", optionB: "발신자 불명의 고수익 의뢰"))
                ),
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "드디어 나도 진짜 개발자구나",
                    pageType: .result(.optionA)
                ),
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "(메일에 개발 의뢰 비용 100억)\n오... 이거 돈이 되는데?",
                    pageType: .result(.optionB)
                )
            ]
        ),
        Scenario(
            id: "career_아무튼 개발자",
            career: .normalDeveloper,
            scenarioType: .normal,
            pages: [
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "첫 출근!\n\"간단한 버그 하나만 고쳐주세요\"\n\n30분 후 : print 12개 추가\n1시간 후 : print 27개 추가\n2시간 후 : 문제 위치를 찾았다.",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "…\n\n문제는 모르겠지만\n위치는 안다",
                    pageType: .story
                )
            ]
        ),
        Scenario(
            id: "career_밤 새는 개발자",
            career: .nightOwlDeveloper,
            scenarioType: .event,
            pages: [
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "오전 5시 58분. 커밋 메시지: 'fix: 됩니다 제발'. 해가 뜨는 걸 이번 달만 네번째 목격했다.",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "(쌓여있는 에너지 드링크)\n도저히 풀리지 않는 치명적인 버그를 만났다.",
                    pageType: .choice(Choice(optionA: "어떻게든 내 실력으로 해결해본다.", optionB: "스택오버플로우와 오픈소스의 도움을 받는다."))
                ),
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "(3시간 뒤, 동료 출근)\n하 거지 같은 세미콜론...",
                    pageType: .result(.optionA)
                ),
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "드디어 해결. 작성자님 감사합니다!\n(작성일 2008년)\n지금은 뭘하시는 분일려나...\n(치킨집 사장님 프로필)",
                    pageType: .result(.optionB)
                )
            ]
        ),
        Scenario(
            id: "career_유능한 개발자",
            career: .skilledDeveloper,
            scenarioType: .normal,
            pages: [
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "후배가 생겼다. 내가 모르는 걸 물어봤다.\n당당하게 GPT에게 질문했다. 그게 개발이다.",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "코드 리뷰에서 처음으로 'LGTM'을 받았다. 액자에 걸고 싶었다.",
                    pageType: .story
                )
            ]
        ),
        Scenario(
            id: "career_유명한 개발자",
            career: .famousDeveloper,
            scenarioType: .event,
            pages: [
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "알림이 계속 울린다\nGitHub 스타가 1만 개를 넘었다.\n\nDM 폭발! \"강의 해주세요\", \"같이 창업해요\", \"형님\"",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "그날 밤 동시에 러브콜이 왔다.\n하나만 골라야 한다.",
                    pageType: .choice(Choice(optionA: "유니콘 스타트업 오퍼 수락", optionB: "개발 유튜브 채널 시작"))
                ),
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "연봉은 올랐다. 퇴근은 사라졌다.",
                    pageType: .result(.optionA)
                ),
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "구독자 12명. 하지만 '형님 덕분에 해결했습니다'라는 첫 댓글이 달렸다.",
                    pageType: .result(.optionB)
                )
            ]
        ),
        Scenario(
            id: "career_올라운더 개발자",
            career: .allRounderDeveloper,
            scenarioType: .normal,
            pages: [
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "어쩌다 보니 기획도 한다. 디자인도 한다. 서버도 나고 앱도 나다. 회의에서 '이거 개발팀이랑 얘기해봐야 할 것 같은데요'라고 했더니",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "모두가 나를 쳐다봤다. 개발팀은 나 뿐이다.\n개발팀 = 나",
                    pageType: .story
                )
            ]
        ),
        Scenario(
            id: "career_월드클래스 개발자",
            career: .worldClassDeveloper,
            scenarioType: .final,
            pages: [
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "0과 1로 대화가 가능해진 지금,\n누군가는 당신을 개발자라 부르고\n누군가는 당신을 미친 사람이라 부른다.\n\n그리고 당신은 안다...\n둘 다 맞다는 걸.",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "scenario_levelup_normal_developer",
                    text: "정점에 선 지금,\n마지막 선택이 남아있다.",
                    pageType: .choice(Choice(optionA: "안정적인 성공", optionB: "인생은 모험과 도전!"))
                )
            ]
        )
    ]
}
