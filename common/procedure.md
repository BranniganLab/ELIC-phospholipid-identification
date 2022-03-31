# Internal Procedure for making and running FEP
# Procedure for setting up the overall system:
- Build the system using standard methods (CHARMM GUI)
- Equilibrate the system using "normal" topologies
- Select and generate the dual-topology patches as needed
- Extend makeAlchemy to handle your patches (first if statement)
- Load your system and trajectory into vmd
- Save the last frame (or last restart coor) as PREFIX.pdb. 
- Rename your psf file to PREFIX.psf.
- Analyze your equilibrium run for the distribution of whatever restraint(s) you may need.
- Copy the sample_TEMPLATE directory, the PREFIX.psf, and the PREFIX.pdb into a new directory.
- Create an appropriate restraint template in the TEMPLATE directory

# Procedure for patching and generating a new replica: 
## Generating the input files
- Open the initial configuration in vmd and select the residue to be mutated. Close vmd.
- Run makeAlchemy.sh like so: >> ./makeAlchemy.sh [resid] [patch] [PREFIX] [path/to/common/directory/with/scripts]
- The script will open vmd and and the colvars dashboard.
- Open the draft restraint which you'll find in ./[patch]_[resid]/[something].[patch]_[restraint].colvars 
- Confirm that the colvar refers to the correct atom (autoselections will not update unless you complete this step)
- Over-write the config file with the one in vmd (this updates the atomselections)
- Close vmd
- The script will do a little cleanup and end.

## Running FEP
- IF you have good internal coordinates you should be able to use the provided starting namd config file. This will run a few steps of minimization and equilibration just to relax the incoming atoms. If your system is unstable, you may need additional minimization/equilibration.
- Check starting...namd to make sure things like the topology directory is correct
- Upload the new directory to an appropriate location on Amarel
- Run "sbatch runEQ.sh" which will run starting...namd
- Run "bash do_run_....sh". The do_run relies on relentless_FEP by Tom Joseph. It's available on Amarel.
