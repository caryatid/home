+|.....................................// timebox spec //---|{{{ |TODO|  timebox spec
 | Fulfills notes and scheduling
 -------------------------------
    aim is to simplify. notes are often too verbose. 
    I should never plan a trivial and obvious action. 
    For example, when planning a porch work area, I do
    not need to jot down; "Find blinds" that is both obvious 
    relatively trivial. On the other hand, I should plan
    the trip to get them if that is required. The former action
    is quick, can be done randomly, and can easily be interrupted
    and rescheduled. The latter task, to travel --  is a blocking
    process that is difficult/costly to interrupt. It is also
    bound by the intersection of free time and open stores.
    This suggests that there are attributes that can be used
    to help identify tasks that require no planning, "incindental"
    and tasks that require plans, "prepense". I chose that word
    just to sound smart.
   
    Anti-actions I think are a tautology. 
    Stop drinking is the action of not drinking? no --  I think
    it is the goal of not drinking which requires specific actions
    more than it requires a non-action. Because it is more about
    changing your mind than your behavior.

    Another goal of simplification is to require the least amount
    of forced habits. For example, trying to stick to a very
    hard schedule with bells and shit failed for me many times.
    I think it failed because I can only handle a couple of forced
    habits at a time [ if that many ]. The aim here is to make
    only a few simple forced habits, like the default question 
    flow chart.

    I think the habit part is most important, once good habits
    are formed about daily planning the rest can fall into place
    to a large degree.  Especially in conjunction with a good
    protocol.


+|.........................// task attribute sets //---|{{{
 |TODO|  task attribute sets
 | some example tasks
 --------------------
    string match for windows in xmonad
        :: prepense ; complex
    find news sources for morning
        :: incindental
    get blah, foo, bar from hardware store
        :: prepense ; time requirements, atomic
    write shell program 
        :: prepense ; complex
            with pipes ; complex
                find piping example ; incindental
                create example; prepense - output
            remembered pipelines ; complex
            completion for common tasks ; complex
    plan a bike tour
        :: prepense; complex
    complete book "foobazitudinal logistics for troglodytes"
        :: prepense ; long term target
    find parsing library
        :: incindental
    learn parsing library
        :: prepense ; uncertain requirements
    read miller again
        :: prepense ; long term target

 | prepense
 ----------
    prepense tasks are recursive. Take `plan a bike tour` from above.
    This will include many sub tasks that are prepense or incindental
    in nature.
    i.e.
        - decide destination :: incindental 
        - plan route :: prepense
          - book lodging if needed :: incindental
          - determine daily ride ability :: prepense
            - plan practice rides :: prepense
        - provisions :: prepense

    | attributes
    ------------
        uncertain requirements
        long term target
        complex ( recursive )
        has an output used by the future
        un-interruptable atomic
        time requirements
        

 | incindental
 -------------
    incindental tasks may take significant time but require
    no planning. 
    | attributes
    ------------
        simply must be done
        does not match prepense attributes



+|........// 0f3d5109-e0a6-4a83-adf2-92d6bbb6bdeb //---|}}}


+|.....................................// tactics //---|{{{
 |TODO|  tactics
 | Techniques to battle tasks
 ----------------------------
    - schedule
        specific time
        re-occuring
        triggered
    - protocol
        default self question -> flow chart
        situational flow charts
    - task lists
        bucket list
            hard to have everywhere
        categorical
        date based
    - habits
        making something never thought of again
 | example model
 ---------------
    eschews scheduling
    incindental may only be placed on the daily todo

    prepense are added to a task list,  one of:
        any bucket
        one of category:
            opportune
            work area lists
            requisites
                these can can be created with a reference to other 
                lists, like primary
    habits:
        morning task list eval and daily todo creation
        default -> flow protocol
        mid day lunch and exercise
        evening journal

    directory structure
        / primary :: link to actual work area
        / archive :: dir
            primary_<date> :: old links
            secondary_<date> :: old links
        / secondary :: link to the actual work area
        / requisite
            req.txt :: list of tasks that other actions await
        / opportune
            opp.txt :: list of tasks that can happen whenever

+|........// d6296127-32f3-4ca0-85e1-6ea2ced50499 //---|}}}

+|.............// 07dc25e1-ac55-4b87-874b-1c76b7219fc3 //---|}}}
