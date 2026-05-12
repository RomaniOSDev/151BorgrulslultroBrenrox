//
//  CultureTipsProvider.swift
//  151BorgrulslultroBrenrox
//

import Foundation

enum CultureTipsProvider {
    enum ActivityKind {
        case cartographer
        case silhouette
        case habit
    }

    /// Short lines for result screens and activity-specific depth.
    static func tip(for kind: ActivityKind, variant: Int) -> String {
        switch kind {
        case .cartographer:
            let lines = [
                "Markets often align along old procession axes—notice how stalls bend around invisible corners.",
                "Bridges and gates were social billboards; their ornament encoded who could pass and when.",
                "Waterfront curves follow cargo drafts, not modern maps—trace the wider arc to feel the old harbor.",
                "Spires cluster where guilds clustered; the skyline is a ledger of labor, not just faith.",
                "Cobble wear patterns show where carts slowed—those pauses became improvised stages for song.",
                "City walls hug thermal pockets; winter winds still respect the same shelter lines centuries later.",
                "Public clocks synchronized work songs; listen for rhythms that outlasted the mechanism.",
                "Lantern spacing once matched night watch routes—odd gaps often hide a retired gatehouse.",
                "Arcades repeat at the length of a rope factory team; width tells you how many shoulders shared a pull.",
                "Corner chamfers on civic buildings spared wagon hubs—run your eye along the diagonal rhythm.",
                "Shade from a single row of trees can mark a buried canal; leaves still favor the moist seam below.",
                "Step height on outdoor stairs sometimes matched loaded crate height—feel the lift in your calves.",
                "Color bands on harbor cranes echoed flag codes; a yellow stripe might mean quarantine, not decoration.",
                "Bell towers staggered so sound arrived in sequence—walk the block and notice the echo relay.",
                "Paving stone size shrinks near cathedrals; pilgrims were meant to slow before thresholds.",
                "Roof pitches differ by snow load region; compare two streets to guess an old boundary line.",
                "Iron rings set low in walls held torches for processions; rust halos are ghost height charts.",
                "Window sill depth tracks latitude of imported glass—deep sills bought time before replacement.",
                "Drain grates point toward the lowest medieval sump; follow the pattern to find a hidden cistern.",
                "Painted house numbers cluster after postal reforms—older walls keep carved or tiled numerals."
            ]
            return lines[abs(variant) % lines.count]
        case .silhouette:
            let lines = [
                "Silhouettes travel faster than text—traders carried folded paper motifs like compressed dialects.",
                "A missing tile in a lattice often marks a taboo topic; the gap is part of the story.",
                "Festival masks borrow from harvest shapes; compare the brow line to local staple crops.",
                "Shadow puppets favor left-to-right reveals because audiences read light like a tide.",
                "Repeating curves in folk art often echo river meanders—follow one motif to a watershed tale.",
                "Negative space in a panel can be the hero; silence was sometimes the punchline.",
                "Border knots encode family alliances; count crossings to guess how many clans shared a loom.",
                "Dawn colors in narrative art are symbolic, not literal—ochre often meant renewal, not sunrise.",
                "Mirrored pairs in tile grids hinted wedding alliances; asymmetry flagged a broken contract.",
                "Animals drawn smaller than humans were not lesser—they stood for seasons, not individuals.",
                "Diagonal hatch fills meant transitional scenes; vertical fills marked judgment or stasis.",
                "Hands with extra fingers in silhouette lore were storytellers, not errors—count the thumb twice.",
                "Boats drawn without oars implied a mythic current; stillness was motion elsewhere.",
                "Crowns made of leaves rather than metal signaled elected leaders, not inherited thrones.",
                "Circles around ankles in cut-paper figures marked dancers who had crossed water to arrive.",
                "Stacked triangles could be mountains or bread ovens—context lived in the border pattern.",
                "Eyes drawn as dots invited audience projection; detailed eyes pinned a tale to one teller.",
                "Spirals at corners protected narrative edges; they were charms against abrupt endings.",
                "Half-revealed tools in a panel asked viewers to name the trade before the next tile fell.",
                "Color inversion between scenes often meant day flipped to spirit realm, not a printing mistake."
            ]
            return lines[abs(variant) % lines.count]
        case .habit:
            let lines = [
                "Small weekly rituals beat grand resolutions—they stack into a portable sense of place.",
                "Logging a habit anchors time zones; the rhythm becomes a compass when jet lag blurs days.",
                "Pair a sensory cue with each log—scent and sound travel deeper than abstract goals.",
                "Lowering a weekly target after travel is honest progress, not a setback.",
                "Habits recorded in transit age differently; note the city name beside the count for context.",
                "Silence counts as data—skipped weeks still teach what environments drain your focus.",
                "Shareable summaries work best when each line names a concrete gesture, not a mood.",
                "Rotating one habit out seasonally keeps the list from feeling like a chore ledger.",
                "Stack habits like courses: light appetizer rituals make heavier weekly goals easier to finish.",
                "If a habit feels vague, rewrite it as a verb plus object plus location—specificity survives fatigue.",
                "Pair a recovery habit with travel days: one minute of stretching beats skipping entirely.",
                "Color-tag your logs mentally: green for social, blue for solo, amber for transit-only wins.",
                "Midweek check-ins catch drift before Sunday guilt; a Wednesday nudge is enough.",
                "Borrow a friend's habit title verbatim if theirs inspires you—shared language builds accountability.",
                "Archive retired habits with one line why they ended; future you reads that like a postcard.",
                "Count streaks in weeks, not days, when crossing borders—weeks forgive a red-eye slip.",
                "If targets feel empty, attach each to a person you greet—habits tied to faces stick.",
                "Batch similar logs on one page of your journal; patterns emerge faster than scattered notes.",
                "Reward completion with a tiny museum visit, not food alone—culture reinforces culture.",
                "When energy dips, shrink scope but keep the slot; showing up preserves the groove."
            ]
            return lines[abs(variant) % lines.count]
        }
    }

    /// General cultural texture for Explore banners and weekly cards.
    static func ambientLine(seed: Int) -> String {
        let lines = [
            "Courtyards remember conversations longer than archives do—listen for echo-friendly corners.",
            "Bread ovens and bell towers often shared stone suppliers; soot rings and patina rhyme.",
            "Night markets inherit medieval curfew lines; closing chants replaced closing gates.",
            "Ferries align with old ford angles; the wake still finds the shallow chord.",
            "Shoemakers clustered near gates because dust from roads paid for leather trials.",
            "Herb stalls hug north-facing walls in hot climates; the microclimate was the first packaging.",
            "Public fountains doubled as bulletin boards; chipped rims show where notes were wedged.",
            "Laundry lanes follow wind roses; flags on balconies still gossip about prevailing breezes.",
            "Railway arches reuse medieval boat sheds; the curve fits hulls and carriages alike.",
            "Tile roofs sing differently in rain—pitch and glaze tell you which district you crossed.",
            "Coffee cups sized to thumbs match old demitasse molds; ergonomics predated ergonomics jargon.",
            "Fence height near schools dipped so adults could see play without entering—trust by design.",
            "Cobble color shifts mark jurisdiction hops; border guards once knelt to check stone suppliers.",
            "Shadow lines at noon still align with meridian markers on some plazas—tourists become sundials.",
            "Door knockers shaped as hands meant welcome without speech; a fist meant debt collection.",
            "Green paint on shutters was algae choice, not fashion—chemists read it as humidity telemetry.",
            "Balcony ironwork repeats lace patterns from export textiles; balconies were vertical showrooms.",
            "Street width equals turning radius for the largest local cart—geometry enforced courtesy.",
            "Corner shops inherit diagonal lots where two guilds refused to yield frontage—peace by wedge.",
            "River steps count in odd numbers on some quays so the last step meets dry land left foot first.",
            "Lantern glass colors filtered gossip: blue for public news, amber for family-only whispers.",
            "Pavement fossils hide in plain sight—some \"stones\" are worn mill wheels pressed into service.",
            "Church keyholes oversized for gloved hands; winter services prioritized warmth over secrecy.",
            "Hatch patterns on manhole covers map utility eras; concentric rings often mean oldest mains below."
        ]
        return lines[abs(seed) % lines.count]
    }

    /// Longer read for Explore lane intros (English UI).
    static func laneDeepDive(lane: String, seed: Int) -> String {
        switch lane {
        case "artisan":
            let blocks = [
                "Workshops once published their skill through façade rhythm: wider bays meant heavier looms inside. Trace how light falls across a street—older crafters chased north light like sailors chase wind.",
                "Pigments traveled as gossip: a new blue arrived harbor-first, then climbed uphill to dyers. When you walk artisan quarters, read rooflines for ventilation stacks; chemistry needed air before secrecy."
            ]
            return blocks[abs(seed) % blocks.count]
        case "folklore":
            let blocks = [
                "Tales compressed geography: a day's walk became three beats in a chorus. Listen for recurring numbers—threes and sevens often marked safe thresholds, not magical decoration.",
                "Masks and puppets borrowed from agrarian calendars; a harvest moon on a cheek might mean debt forgiven at equinox. Silhouettes carried those codes when paper was dear."
            ]
            return blocks[abs(seed) % blocks.count]
        case "culinary":
            let blocks = [
                "Spice routes wrote flavor into stone: mortar marks on quayside steps differ from grain-only ports. Steam vents near alleys still betray where communal kitchens fed shift workers.",
                "Fermentation followed prayer bells because temperature tracked choir schedules. A sour note in a recipe might encode humidity, not taste preference—read ingredients as weather logs."
            ]
            return blocks[abs(seed) % blocks.count]
        default:
            return ambientLine(seed: seed)
        }
    }
}
