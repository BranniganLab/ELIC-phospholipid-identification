# Internal Procedures for making and running FEP
## Procedure for setting up the overall system:
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
## Generating the input files (patching)
- Open the initial configuration in vmd and decide which residue (resid) to be mutated. Close vmd.
- *IMPORTANT: extracted frames from trajectories may cause psfgen to crash. Regenerate the psf using regenerate_psf.py by Tom Joseph before continuing.*
- Run makeAlchemy.sh like so: >> ./makeAlchemy.sh [resid] [patch] [PREFIX]
- The script will open vmd and update the colvars
- Check the incoming and outgoing atoms (colored by beta)
- Confirm that the colvar refers to the correct atom 
- Close vmd
- The script will do a little cleanup and end.
- All necessary files will be found in ./[patch]_[resid]

## Running FEP
- IF you have good internal coordinates you should be able to use the provided starting namd config file. This will run a few steps of minimization and equilibration just to relax the incoming atoms. If your system is unstable, you may need additional minimization/equilibration.
- Check starting...namd to make sure things like the topology directory is correct
- Upload the new directory to an appropriate location on Amarel
- Run "sbatch runEQ.sh" which will run starting...namd
- Run "bash do_run_....sh". The do_run relies on relentless_FEP by Tom Joseph. It's available on Amarel.

## Removing a headgroup (depatching):
- Get a psf and pdb of an appropriate state
- Save them as parent/prefix/prefix.psf and parent/prefix/prefix.pdb (make sure the pdb is a single frame, not a trajectory)
- In the parent directory run:
>> /path/to/common/unAlchemize.sh prefix newRes /path/to/common 
- This will create a new psf and pdb with the targetRes in place of the original dual topology. These can then be used as inputs for either ABFE or loop closure.
- CAUTION: this assumes you're using the other scripts for file generation. Strange things may happen if you have custom named files. (Note to self: make these scripts more robust to different file names)

# ABFE Calculations
## Making the inputs for ABFE Calculations:
- run /path/to/common/makeABFE.sh
