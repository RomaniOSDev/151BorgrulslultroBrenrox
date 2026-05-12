//
//  CollectionCatalog.swift
//  151BorgrulslultroBrenrox
//

import Foundation

struct CollectionInsightCard: Identifiable, Hashable {
    let id: String
    let title: String
    let prose: String
}

enum CollectionCatalog {
    static func cards(for deckIndex: Int) -> [CollectionInsightCard] {
        switch deckIndex {
        case 0:
            return [
                CollectionInsightCard(
                    id: "weave-dye",
                    title: "Indigo breath",
                    prose: "Slow vats teach patience: cloth dipped dozens of times carries sky depth, not a single dunk. Dyers listened to humidity the way captains listen to barometers—one rushed dip could waste a week of labor."
                ),
                CollectionInsightCard(
                    id: "weave-loom",
                    title: "Rhythm underfoot",
                    prose: "Pedal patterns were memorized songs—mistakes in beat showed up as stripes long before they were named errors. Apprentices learned counting through soles, not chalkboards."
                ),
                CollectionInsightCard(
                    id: "weave-mend",
                    title: "Visible repair",
                    prose: "Highlighting a mend honored breakage; a golden thread line was a diary entry others could read in public. Some families reserved a signature stitch angle so repairs could be recognized across markets."
                ),
                CollectionInsightCard(
                    id: "weave-shear",
                    title: "Shearing calendars",
                    prose: "Wool quality shifted with moon-folklore as much as weather; certain nights were avoided for cuts because oil from hands was thought to travel farther in damp air."
                ),
                CollectionInsightCard(
                    id: "weave-band",
                    title: "Selvage stories",
                    prose: "Tight selvage edges carried hidden maker marks—tiny colored threads spelled guild and city for inspectors who never unfolded the bolt fully."
                ),
                CollectionInsightCard(
                    id: "weave-smoke",
                    title: "Smoke signals indoors",
                    prose: "Drying rooms vented in spirals so smoke tinted fibers evenly; a darker ceiling stain above one corner meant a prized recipe, not neglect."
                )
            ]
        case 1:
            return [
                CollectionInsightCard(
                    id: "ember-call",
                    title: "Call-and-response nights",
                    prose: "Winter tales lengthened with each answer from the crowd—silence meant the story had not yet earned heat. Listeners paid with noise, not coins."
                ),
                CollectionInsightCard(
                    id: "ember-season",
                    title: "Seasonal swaps",
                    prose: "Characters traded masks at solstice thresholds; the same voice could play summer trickster and winter judge. Costume weight hinted at the stamina required for the dance that followed."
                ),
                CollectionInsightCard(
                    id: "ember-lantern",
                    title: "Lantern grammar",
                    prose: "How a lantern swung at a doorway signaled safe entry—three short arcs invited listeners, one long arc meant hush. Children learned grammar before literacy through those swings."
                ),
                CollectionInsightCard(
                    id: "ember-bridge",
                    title: "Bridge riddles",
                    prose: "Crossing tales demanded a wrong answer first; the bridge spirit wanted humility before cleverness. Rivers collected tolls in stories instead of coins."
                ),
                CollectionInsightCard(
                    id: "ember-ash",
                    title: "Ash marks",
                    prose: "Foreheads marked with ritual ash carried district codes—curves versus dots told which shrine sponsored a traveler, not which deity they favored."
                ),
                CollectionInsightCard(
                    id: "ember-echo",
                    title: "Echo courts",
                    prose: "Courtyards built for call-and-response had one dead wall to kill slapback; clapping games there were tuning forks for architecture."
                )
            ]
        case 2:
            return [
                CollectionInsightCard(
                    id: "table-ferment",
                    title: "Ferment clocks",
                    prose: "Household crocks listened to church bells; skim schedules followed prayer more than printed minutes. A missed bell could mean a sweeter batch—or a risky one."
                ),
                CollectionInsightCard(
                    id: "table-spice",
                    title: "Spice debt",
                    prose: "Borrowed pinches were repaid in labor—grinding a neighbor's mix built trust faster than coin did. Some debts were settled in song during grinding shifts."
                ),
                CollectionInsightCard(
                    id: "table-cloth",
                    title: "Shared cloth etiquette",
                    prose: "Placing bread toward the center cloth edge meant all could tear; folding corners away reserved a slice for travelers. Breaking that fold was ruder than refusing wine."
                ),
                CollectionInsightCard(
                    id: "table-broth",
                    title: "Broth hierarchy",
                    prose: "First boil fed workers, second fed elders, third fed gardens—waste was sequenced, not hidden. Ladles hung in length order so everyone knew which pot they drew from."
                ),
                CollectionInsightCard(
                    id: "table-salt",
                    title: "Salt cellars and treaties",
                    prose: "Shared salt at table could seal informal truces; passing it left-handed was a coded decline in some ports, a blessing in others—travelers learned both."
                ),
                CollectionInsightCard(
                    id: "table-ember",
                    title: "Ember ovens",
                    prose: "Bread ovens banked coals overnight for slow beans; morning heat was budgeted like currency. Families read crust color as yesterday's weather report."
                )
            ]
        default:
            return []
        }
    }
}
