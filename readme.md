# Multi-Agent System Formation Control

This project is an implementation of the following journal paper:
```
W. Lin et al., “Distributed formation control with open-loop Nash strategy,” Automatica, vol. 106, pp. 266–273,
Aug. 1, 2019, issn: 0005-1098. doi: 10.1016/j.automatica.2019.04.034.
```

The block diagram in Simulink:
![](https://imgur.com/0v20DKN.png=400x)

The simulated trajectories:
![](https://imgur.com/1wgkmpy.png=400x)

## Quick Start
1. Add module folders (evaluation, initialization, models, strategies, and viz) and all their subfolders to MATLAB path by selecting them in `Project Explorer` and right-clicking `Add to Path` > `Selected Folders and Subfolders`.
2. Run `run_simulation.m` via MatLab.

The parameters of the simulation are defined in different files according to their purpose:
- `run_simulation.m`: Main script to run the simulation. You can add new plots here.
- `initialization/param_init.m`: This file will be called by `run_simulation.m` to initialize global parameters, which is listed in [Parameters](#Parameters), and it will also invoke other initialization files for desired formation definitions, initial state, and other parameters for strategies.
- `initialization/v_shape`: This folder contains initialization scripts for a V-shape formation, including the initial state of agents, the desired formation, and the agent dynamics.
- `initialization/dfc_automatica`: This folder contains initialization scripts for the example in the paper.
- `initialization/strategy_dfc_opnash.m`: This script contains parameters for the strategy.

## Parameters
After running `param_init.m`, the following structs will be defined in the workspace, and they will be treated as global variables in the simulation:
- `params`: information about number of agents, initial and termain time.
- `initial`: the initial state of agents.
- `model`: the system dynamics of agents in state space representation.
- `graph`: the communication topology.
- `formation`: parameters for the desired formation.
- `dfc_opnash`: parameters for the strategy.