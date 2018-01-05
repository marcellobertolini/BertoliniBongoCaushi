open util/boolean
open util/ordering[Time]
open util/ordering[Trip]
open util/ordering[Event]
open util/ordering[EventPath]

//SIGNATURES
abstract sig Event {
	startTime : one Time, 
	endTime : one Time
}

abstract sig Mean {}

sig User {
	userPreferences : one Preference, 
	userCalendar :  one Calendar, 
	userPosition : one Position, 
	trips : set Trip 
}

sig EventPath {
	startingPosition : one Position, 
	endingPosition : one Position, 
	timeNeeded : one Int, 
	mean : one Mean 
}{
	timeNeeded > 0
	startingPosition != endingPosition
	mean in ( Bus +  Metro + Tram + CarSharing + BikeSharing + Car )
}

sig Day {
	events : set Event, 
	date : one Date 
}

sig Calendar {
	days : some Day 
}

sig Date {}

sig Time {}

sig Appointment extends Event {
	location : one Position, 
	eventTag : one Tag, 
	eventSolution : set EventSolution, 
	carbonFootprint : one Bool 
}

sig Lunch extends Event {} 

sig Break extends Event {}

sig EventSolution {
	startPath : one EventPath, 
	endPath : one EventPath, 
	intermediatePath : set EventPath 
}{
	no x: intermediatePath | startPath = x or endPath = x
	lone x: intermediatePath | startPath.endingPosition = x.startingPosition
	lone x: intermediatePath | endPath.startingPosition = x.endingPosition
	no x: intermediatePath | startPath.startingPosition = x. endingPosition

	all x: intermediatePath | x.endingPosition = endPath.startingPosition or 
	one x1: intermediatePath | x.endingPosition = x1.startingPosition

	all x: intermediatePath | x.startingPosition = startPath.endingPosition or
	one x1: intermediatePath | x.startingPosition = x1.endingPosition 	
	#intermediatePath = 0 implies (startPath = endPath or startPath.endingPosition = endPath.startingPosition)

	startPath.startingPosition != endPath.endingPosition

	all x: startPath, y: intermediatePath | x.startingPosition not in (y.startingPosition + y.endingPosition) 
	all x: endPath, y: intermediatePath | x.endingPosition not in (y.startingPosition + y.endingPosition) 
}

//Only travel between towns
sig Travel extends Event {
	startingLocation : one Position, 
	endingLocation: one Position, 
	meanOfTransport : one Mean, 
	date : one Date, 
	durantionTime : one Int 
}{
	startingLocation != endingLocation
	meanOfTransport in (Train + Airplane + Car + Bus)
}

sig Trip {
	accomodation : one Position,
	departureTravel : one Travel, 
	returnTravel : one Travel
}{
	departureTravel != returnTravel
	returnTravel.startingLocation = departureTravel.endingLocation
	returnTravel.date != departureTravel.date.next
}

sig Position {}

sig SeasonTicket {
	isValid : one Bool,
	validThru : one Date
}

sig Tag {
	means : some Mean, 
	anticipationTime : one Int 
}{	
	anticipationTime > 0
	means in ( Bus +  Metro + Tram + CarSharing + BikeSharing + Car )
}

one sig Train extends Mean {}

one sig Airplane extends Mean {}

one sig Bus extends Mean {}

one sig Metro extends Mean {}

one sig Tram extends Mean {}

one sig Bike extends Mean {}

one sig BikeSharing extends Mean {}

one sig Car extends Mean {}

one sig CarSharing extends Mean {}

one sig Walking extends Mean {}

sig Preference {	
	lunchInfo : lone LunchInfo,
	breakInfo : set BreakInfo,
	residence : one Position, 
	tags : some Tag, 
	carbonFootprint : one Bool,
	availableMeans : some Mean, 
	seasonTicket : one SeasonTicket 
}{
	availableMeans in ( Bus +  Metro + Tram + CarSharing + BikeSharing + Car + Bike + Walking + Train )
}

sig LunchInfo {
	startTime : one Time,
	endTime : one Time, 
	duration : one Int 
}{
	duration > 0 
}

sig BreakInfo {
	startBreakTime : one Time,
	endBreakTime : one Time, 
	duration : one Int, 
	minimumDuration : one Int
}{
	duration > 0 
}

//FACTS
fact OnePreferenceForEachUser {
	all p: Preference | some u: User | p in u.userPreferences
	all u: User | no u':User | u.userPreferences = u'.userPreferences and u != u'
}

fact tripsAreUniqueForEachUser {
	all u: User | u.trips.departureTravel != u.trips.departureTravel.next and
		 u.trips.returnTravel != u.trips.returnTravel.next

	all t: Trip | some u: User | t in u.trips
}

fact daysUniqueInForCalendar {
	all c, c': Calendar | c != c' 
		implies c.days & c'.days = none
}

fact calendarUnique {
	all u, u': User | u != u' 
		implies u.userCalendar != u'.userCalendar
}

fact allCalendarAreInTheUser {
	all c: Calendar | one u: User | c in u.userCalendar  
}

fact allEventsAreInAday {
	all e: Event | some d: Day | e in d.events
}

fact allDaysAreInAllCalendars {
	all d: Day| some c: Calendar | d in c.days
}
		
fact dateOnlyWithLink {
	all d: Date | some g: Day, s: SeasonTicket, t: Travel |
		d in ( g.date + s.validThru + t.date )
}

fact timeHasToHaveAlink {
	all t: Time | some b: BreakInfo, l: LunchInfo, e: Event |
		t in ( b.startBreakTime + b.endBreakTime + l.startTime + l.endTime +
			e.startTime + e.endTime	)
}
				
fact eventSolutionOnlyInAppointment {
	all s: EventSolution | some a: Appointment | s in a.eventSolution
}

fact startTimeBeforeEndTime {
	all e: Event | e.endTime = e.startTime.next
}


fact startPathDifferentFromEndPath {
	all s: EventSolution | #s.intermediatePath > 0
		implies s.startPath != s.endPath
}

fact NoEventPathWithoutEventSolution {
	all p: EventPath | some s: EventSolution | p in s.startPath + s.intermediatePath + s.endPath
}

fact everyTravelHasATrip {
	all t: Travel | some tr: Trip |
		t in ( tr.departureTravel + tr.returnTravel )
}

fact accomodationDifferentFromTravelsLocations {
	all tr: Trip | no t: Travel |
		t.startingLocation in tr.accomodation or t.endingLocation in tr.accomodation 
}

fact noLunchInfoWithoutPreference {
	all l: LunchInfo | some p: Preference | l in p.lunchInfo
}

fact noBreakInfoWithoutPreference {
	all b: BreakInfo | some p: Preference | b in p.breakInfo
}

fact lunchAndBreakStartAndEndTimeDifferent {
	all l: LunchInfo | l.startTime != l.endTime
}

fact BreakStartAndEndDifferentTime {
	all b: BreakInfo | b.startBreakTime != b.endBreakTime
}

fact EveryBreakInApreferenceWithDifferentTime {
	all p: Preference | some b, b': BreakInfo |
		b != b' and b in p.breakInfo and b' in p.breakInfo
			implies
				b.startBreakTime != b'.startBreakTime and
				b.endBreakTime != b'.endBreakTime 
}

fact breakInfoConsistent {
	#breakInfo = #Break
}

//There is a lunch event only if the related lunchInfo has been set
fact lunchPresentIfSet {
	all u: User | all d: Day | some l: Lunch | 
		#u.userPreferences.lunchInfo.startTime = 1 and d in u.userCalendar.days
			implies l in d.events
}

//There is a Break event only if the related breakInfo has been set
fact breakPresentIfSet {
	all u: User | all d: Day | some b: Break | 
		#u.userPreferences.breakInfo.startBreakTime = 1 and d in u.userCalendar.days
			implies b in d.events
}

fact startLunchTimeConsistent {
	all u: User | 
		u.userPreferences.lunchInfo.startTime = ( u.userCalendar.days.events & Lunch ).startTime
}

fact startBreakTimeConsistent {
	all u: User | 
		u.userPreferences.breakInfo.startBreakTime = ( u.userCalendar.days.events & Break ).startTime
}

fact endBreakTimeConsistent {
	all u: User | 
		u.userPreferences.breakInfo.endBreakTime = ( u.userCalendar.days.events & Break ).endTime
}

fact lunchCannotBeSharedBetweenDifferentCalendar {
		all c, c': Calendar | some l: Lunch |
		 c' != c 
			implies
				#( c.days.events & l ) = 1 and #( c'.days.events & l ) = 0 or
				#( c.days.events & l ) = 0 and #( c'.days.events & l ) = 1
}	

fact BreakCannotBeSharedBetweenDifferenctCalendar {
		all c, c': Calendar | some b: Break |
		 c' != c 
			implies
				#( c.days.events & b ) = 1 and #( c'.days.events & b ) = 0 or
				#( c.days.events & b ) = 0 and #( c'.days.events & b ) = 1		
}	

fact maximumOneLunchPerDay {
	all d: Day | #( d.events & Lunch ) = 1
}

fact numberOfLunchConstraint {
	 #userPreferences.lunchInfo.startTime = #Lunch 
}

fact numberOfBreakConstraint {
	 #userPreferences.breakInfo.startBreakTime = #Break 
}



fact meanOnlyWithLink {
		all m: Mean | some p: Preference, t: Tag, e: EventPath, t' : Travel | m in ( p.availableMeans + t.means + e.mean + t'.meanOfTransport )
}

fact SeasonTicketOnlyInPreference {
	all s: SeasonTicket | some p: Preference | s in p.seasonTicket
}

fact lunchTimeDefinition {
	all p: Preference | 
			#p.lunchInfo.startTime = 1 iff #p.lunchInfo.endTime = 1
		or
			#p.lunchInfo.startTime = 0 iff #p.lunchInfo.endTime = 0

	all p: Preference | 
		#p.lunchInfo.duration = 1 iff #p.lunchInfo.startTime = 1
		or
		#p.lunchInfo.duration = 0 iff #p.lunchInfo.startTime = 0	
}

 fact StartLunchTimeGreaterThanEndLunchTime {
	 all p:Preference | p.lunchInfo.endTime = p.lunchInfo.startTime.next
 }

fact noTagsWithoutLink {
	all t: Tag | some a: Appointment |
		t in a.eventTag
}

//ASSERTS
assert numCalendarEqualNumberUser {
	#User = #Calendar
}

assert meansConstraint {
	all m: Mean | some p: Preference, t: Tag, e: EventPath, t': Travel | m in ( p.availableMeans + t.means + e.mean + t'.meanOfTransport )
}

assert sameLunchInDifferentCalendars {
	all c, c': Calendar | some l: Lunch |
		 c' != c 
			implies #( c.days.events & l ) = 1 and #( c'.days.events & l ) = 1	
}

assert addEventConsistency {
	all d, d', d'': Day, e, e': Event |
		 e != e' and addEvent[d, d', e] and addEvent[d', d'', e']
			implies d''.events = d.events + e + e'
}

//PREDICATES
pred show {}

pred oneCalendarForUser {
	all u: User | #u.userCalendar = 1
}

pred addEvent [ d, d': Day, e: Event ] {
	d'.events = d.events + e
}

pred addTrip [ u, u': User, t: Trip, a: Position, t1: Travel, t2: Travel ] {
	t.accomodation = a and t.departureTravel = t1 and t.returnTravel = t2 and
	u'.trips = u.trips + t
}


//CHECKS
check numCalendarEqualNumberUser
check meansConstraint
check addEventConsistency
check sameLunchInDifferentCalendars

//RUNS
run addTrip for 8 but 2 Trip, 5 Position, 2 Day, 2 Travel, 5 Event 
run show  for 6 but 2 Trip, 4 Position, 2 Day, 2 Travel, 4 EventPath, 4 Time, 2 EventSolution, 4 Time
run addEvent for 5 but 1 Trip, 1 EventSolution, 2 Day, 5 Event, 2 EventPath
run oneCalendarForUser for 6


