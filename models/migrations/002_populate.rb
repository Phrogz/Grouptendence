Sequel.migration do
    up do
        from(:confirmation_types).multi_insert([
            {id:0, label:"Unknown", image:"unknown.png"},
            {id:1, label:"Confirmed", image:"confirmed.png"},
            {id:2, label:"Tentative", image:"tentative.png"},
            {id:3, label:"Declined", image:"declined.png"},
        ])

        from(:events).multi_insert([
            {
                id:"blu-outdoor",
                name:"Boulder Lunchtime Ultimate - Outdoor",
                location:"[Valmont Disc Golf Park](https://www.google.com/maps/@40.0274548,-105.2374148,418m/data=!3m1!1e3); sometimes [East Boulder Rec](https://www.google.com/maps/@39.9921613,-105.2240977,209m/data=!3m1!1e3)",
                description:"Free pickup open to all ages and skill levels; bring a white and dark shirt."
            },
            {
                id:"blu-indoor",
                name:"Boulder Lunchtime Ultimate - Indoor",
                location:"[Boulder Indoor Soccer](https://goo.gl/maps/xocB5ts9cXvTZKdF9)",
                description:<<~DESCRIPTION
                    Pickup ultimate open to all ages and skill levels; bring a white and dark shirt/jersey.
                    Cost is $7 to the facility. (Second day in the same week is only $3.)

                    Indoor ultimate uses slightly different rules than outdoor. Games are to time (e.g. 20 minutes), with smaller teams (e.g. 5v5) on the field.
                    Play (and the clock) does not stop after a score: the scoring team puts the disc on the ground and the other team picks it up and plays on.
                    Substitutions take place on the fly (as in hockey). The disc may be played off the wall or roof.

                    The time slot is a nominal two hours; we usually stop playing around 1:45p.
                    However, with 20 minute games, you can choose to leave earlier if needed.
                DESCRIPTION
            },
            {
                id:"blu-ggm",
                name:"BLU Great-Grandmasters Pickup",
                location:"[Valmont Disc Golf Park](https://www.google.com/maps/@40.0274548,-105.2374148,418m/data=!3m1!1e3); sometimes [East Boulder Rec](https://www.google.com/maps/@39.9921613,-105.2240977,209m/data=!3m1!1e3)",
                description:"Pickup ultimate limited to 'the elderly' ;)"
            },
        ])

        from(:event_times).multi_insert([
            {event_id:'blu-indoor', starts_at:'20221202T1200-07', minutes:120},
            {event_id:'blu-indoor', starts_at:'20221207T1200-07', minutes:120},
            {event_id:'blu-indoor', starts_at:'20221209T1200-07', minutes:120},
            {event_id:'blu-indoor', starts_at:'20221214T1200-07', minutes:120},
            {event_id:'blu-indoor', starts_at:'20221216T1200-07', minutes:120},
            {event_id:'blu-indoor', starts_at:'20221221T1200-07', minutes:120},
            {event_id:'blu-indoor', starts_at:'20221223T1200-07', minutes:120},
            {event_id:'blu-indoor', starts_at:'20221228T1200-07', minutes:120},
            {event_id:'blu-indoor', starts_at:'20221230T1200-07', minutes:120},
        ])

        from(:signups).multi_insert([
            {event_time_id:3, name:'Gavin K.', confirmation_type_id:1},
            {event_time_id:3, name:'Anshu', confirmation_type_id:1},
            {event_time_id:3, name:'Wil', confirmation_type_id:2},
            {event_time_id:3, name:'Byron', confirmation_type_id:3},

            {event_time_id:4, name:'Gavin K.', confirmation_type_id:1},
            {event_time_id:4, name:'Christian', confirmation_type_id:1},
            {event_time_id:4, name:'VB', confirmation_type_id:1},
            {event_time_id:4, name:'Xue', confirmation_type_id:1},
        ])
    end

    down do
        from(:confirmation_types).delete
        from(:events).delete
        from(:event_times).delete
    end
end
