#@+leo-ver=5
#@+node:@button make-skull
# skulls is a basic grammar
# skulls = mode
# mode = controller controller
# controller = mod? actions*
# mod = actions*
# actions = TERM mode?
def actions(poss, buttons, mod=""):
    retval = []
    for pos, button in zip(poss, buttons):
        actName = pos.h.replace("@mode ", "")
        retval.append("enter-" + actName + "-mode -> same = " + mod + button)
    return '\n'.join(retval) + '\n'

def modifier(pos, buttons):
    names = [x.strip() for x in pos.h.split()]
    modName = names[0].lower().capitalize() + "-"
    acts = [x.copy() for x in pos.children()]
    return "# " + modName + " " + " ".join(names[1:]) + '\n' + actions(acts,buttons, mod=modName) + '\n'

def controller(pos, buttons="wasdqe"):
    contName = pos.h.strip().lower()
    # mod?
    mods = []
    acts = [x.copy() for x in pos.children()]
    while not acts[0].h.startswith("@mode "):
        mods.append(modifier(acts[0], buttons))
        acts = acts[1:]
    return "# " + contName + '\n'  + actions(acts,buttons) + '\n'.join(mods) + '\n'
    
def skulls (pos):
    modeName = pos.h.replace("@mode ", "").lower()
    cont = []
    for x in pos.children():
        cont.append(x.copy())
    return "# " + modeName + '\n'+ controller(cont[0]) + controller(cont[1],buttons="ijkluo")
    
    
p.b = skulls(p)
#@-leo

