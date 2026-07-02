//
//  DefaultScenarioRepository.swift
//  SoloDeveloperTraining
//
//  Created by Gemini on 1/24/26.
//

import Foundation

final class DefaultScenarioRepository: ScenarioRepository {

    func fetchScenario(for career: Career) -> Scenario? {
        return allScenarios.first { $0.career == career }
    }

    func fetchRebirthScenarioPages() -> [ScenarioPage] {
        return [
            ScenarioPage(
                imageName: "rebirthStory1",
                text: """
                내가 태어난 곳은
                문명과 거리가 먼 산촌한 항구리
                """,
                pageType: .story
            ),
            ScenarioPage(
                imageName: "rebirthStory2",
                text: """
                특별한 것 없이 무난하게 성장해왔고,
                그냥 그러저럭 살아왔다.
                """,
                pageType: .story
            ),
            ScenarioPage(
                imageName: "rebirthStory3",
                text: """
                그럭저럭 살다보니
                어느덧 대학교를 졸업했고
                """,
                pageType: .story
            ),
            ScenarioPage(
                imageName: "rebirthStory4",
                text: """
                나는 그렇게...
                '백수'가 되었다.
                """,
                pageType: .story
            )
        ]
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

    // MARK: - Hardcoded Data
    // TODO: 시나리오 텍스트, 이미지 수정
    private let allScenarios: [Scenario] = [
        Scenario(
            id: "career_백수",
            career: .unemployed,
            scenarioType: .normal,
            pages: [
                ScenarioPage(
                    imageName: "unemployed1",
                    text: "졸업 한지 벌써 세 달.\n오늘은 생산적인 하루를 보내기로 했다.",
                    pageType: .story
                ),

                ScenarioPage(
                    imageName: "unemployed2",
                    text: "오늘 내가 한일 정리해볼까?\n(사실은 유튜브만 3시간째 보는중)",
                    pageType: .story
                ),

                ScenarioPage(
                    imageName: "unemployed3",
                    text: "비전공자 개발자되기? 이게 뭐지...",
                    pageType: .story
                ),

                ScenarioPage(
                    imageName: "unemployed4",
                    text: "개발자라... 나도 도전해볼까?",
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
                    imageName: "laptopOwner1",
                    text: "당근나라에서 15만원짜리 중고 노트북을 샀다.",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "laptopOwner2",
                    text: "노트북에서 비행기 이륙할 때 소리가 나긴 하지만",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "laptopOwner3",
                    text: "일단 노트북에 스티커를 붙여본다.",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "laptopOwner4",
                    text: "됐다! 난 이제 개발자다.",
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
                    imageName: "aspiringDeveloper1",
                    text: "print... hello world... 이게 진짜될까?",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "aspiringDeveloper2",
                    text: "일단 엔터~ 가보자고!! 으아아아앗!!",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "aspiringDeveloper3",
                    text: "화면에... 글자가 찍혔다.",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "aspiringDeveloper4",
                    text: "이건 좀... 감동이잖아? (글썽)",
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
                    imageName: "juniorDeveloper1",
                    text: "저 사람들... 혹시 나한테 하는 말인가?",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "juniorDeveloper2",
                    text: "칭찬인것 같기도... 욕인 것 같기도...오묘한 기분.",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "juniorDeveloper3",
                    text: "스팸이 아니었잖아? 어떤걸 먼저 열어보지...",
                    pageType: .choice(Choice(optionA: "모 기업 최종 합격 메일", optionB: "발신자 불명의 고수익 의뢰"))
                ),
                ScenarioPage(
                    imageName: "juniorDeveloper4",
                    text: "오호라...! 본격적으로 개발자가 되는거야!",
                    pageType: .result(.optionA)
                ),
            ]
        ),
        Scenario(
            id: "career_아무튼 개발자",
            career: .normalDeveloper,
            scenarioType: .normal,
            pages: [
                ScenarioPage(
                    imageName: "normalDeveloper1",
                    text: "오늘은 내 첫 출근일! 화이팅 해보자고~",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "normalDeveloper2",
                    text: "첫 미션인가...? 간단한거면 본인이 하지 왜..",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "normalDeveloper3",
                    text: "흠... 간단한 문제긴 한데... 쉽지 않네.",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "normalDeveloper4",
                    text: "어디가 문제지...?! 어디야 !! 어디냐고 !!!",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "normalDeveloper5",
                    text: "문제는 몰라도 위치는 찾았다.\n헤헷! 역시 나야 ~",
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
                          imageName: "nightOwlDeveloper1",
                          text: "오전 5시 58분. 커밋 메시지: 'fix: 됩니다 제발'.",
                          pageType: .story
                      ),
                      ScenarioPage(
                          imageName: "nightOwlDeveloper2",
                          text: "해가 뜨는 건 이번 달만 네 번째 목격했다.",
                          pageType: .story
                      ),
                      ScenarioPage(
                          imageName: "nightOwlDeveloper3",
                          text: "도저히 풀리지 않는 치명적인 버그를 만났다.",
                          pageType: .story
                      ),
                      ScenarioPage(
                          imageName: "nightOwlDeveloper4",
                          text: "어떻게 해결할까...",
                          pageType: .choice(
                              Choice(
                                  optionA: "어떻게든 내 실력으로 해결해본다.",
                                  optionB: "스택오버플로우와 오픈소스의 도움을 받는다."
                              )
                          )
                      ),
                      ScenarioPage(
                          imageName: "nightOwlDeveloper5",
                          text: "하 거지 같은 세미콜론...",
                          pageType: .result(.optionA)
                      )
            ]
        ),
        Scenario(
            id: "career_유능한 개발자",
            career: .skilledDeveloper,
            scenarioType: .normal,
            pages: [
                ScenarioPage(
                    imageName: "skilledDeveloper1",
                    text: "네?!?! 네! 네네! 지, 지, 질문 이 뭐 머, 뭔가요?\n( 후배는 아직 어색하다. )",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "skilledDeveloper2",
                    text: "아 이거 간단한 문제에요.\n제가 하던 일 먼저 하고 도와드릴게요.",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "skilledDeveloper3",
                    text: "하... 놀랬네. 질문이 뭐였지? AI한테 물어보자.\n이게 바로 바이브 코딩 아니겠어~",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "skilledDeveloper4",
                    text: "뭐지? 코드 리뷰 승인... LGTM ? !",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "skilledDeveloper5",
                    text: "내가 LGTM을 받다니. 너무너무너무 행복하잖아~~",
                    pageType: .story
                ),
                ScenarioPage(
                    imageName: "skilledDeveloper6",
                    text: "후훗~ 이것도 기념인데 액자로 만들어서 걸어둘까?",
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
