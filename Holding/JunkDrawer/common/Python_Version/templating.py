from string import Template
from glob import glob

def templateAll(affix, resid, in_names, out_names):
    '''Templates all in_names files to out_names files using an affix and resid'''
    the_map = {'TEMPLATE_resid':resid, 'TEMPLATE_affix':affix}
    for in_file, out_file in zip(in_names, out_names):
        print(in_file)
        print(out_file)
        templateFile(the_map, in_file, out_file)

def templateFile(the_map, in_name, out_name):
    with open(in_name, 'r') as f:
        src = Template(f.read())
        result = src.substitute(the_map)
        OF = open(out_name, 'w')
        OF.write(result)
        OF.close() 
    return

def makeABFEtcl(common_path, resid, prefix_in, prefix_out):
    ABFE_map = {'common_path':common_path, 'resid':resid, 'prefix_in':prefix_in, 'prefix_out':prefix_out}
    templateFile(ABFE_map, "ABFE_TEMPLATE.tcl", f"{prefix_out}.tcl") 
    
def getNamesOut(patchName):
    '''Particular to phospholipid headgroup mutations. E.g. POEG == pe to pg on PO acyl chains'''
    key = patchName[2]
    if key == 'C':
        names_out = "C15 H15A H15B H15C C14 H14A H14B H14C C13 H13B H13A H13C N H12B C12 H12A H11B C11 H11A O12 P O14 O13 O11"
    elif key == 'G':
        names_out = "O11 P O13 O14 O12 C11 H11B H11A H12A C12 OC2 HO2 C13 H13A H13B OC3 HO3"
    elif key == 'E':
        names_out = "C11 N C12 HN2 O12 O13 P HN1 O14 O11 H12W H12V HN3 H11V H11W H12A H12B H11A H11B"
    else:
        print(f"ERROR: I don't know what to do with '{patchName}'")
        return 0
    print("Don't forget to make sure the ALL the right atoms are being (de)coupled!")
    return names_out        

def makeRBFEtcl(common_path, resid, patch_name, prefix_in, prefix_out, segid):
    names_out = getNamesOut(patch_name)
    RBFE_map = {'common_path':common_path, 'resid':resid, 'prefix_in':prefix_in, 'prefix_out':prefix_out, 'patch_name':patch_name, 'names_out':names_out, 'seg':segid}
    templateFile(RBFE_map, "RBFE_TEMPLATE.tcl", f"{prefix_out}.tcl")