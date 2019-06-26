"""
Airport Security Simulation

Scenario:
  An airport has a limited number of ID Checkpoints and
  Personal Checkpoints that share a common queue. 
  Passengers randomaly arrive at the airport and wait to
  go through the ID Checkpoint then the Personal Checkpoint.

  An airport has a control process to monitor the security queue.
  They can staff more or less officers at the two types of checkpoints.
  The airports wants to ensure an expedient queue, so the objective is to
  keep the average passenger wait time below 15 mins, while minimizing staffing.
"""

import itertools
import numpy as np
import simpy

RANDOM_SEED = 1234
SIM_TIME = 600
LAMBDA_ARRIVAL = 0.2
BETA_ID_CHECKPOINT = 0.75
LOW_PERSONAL_CHECKPOINT = 0.5
HIGH_PERSONAL_CHECKPOINT = 1
ID_CHECKPOINT_STAFF = 4
PERSONAL_CHECKPOINT_STAFF = 5


def passenger(name, env, id_check, personal_check):
    """
    A passenger arrives at the airport, but must clear security before catching their flight.

    The passenger requests to go through an ID Checkpoint, then requests to go through a Personal Checkpoint.
    """
    t_security_start = env.now

    # print('%s is ready to have their id checked %.1f' % (name, env.now))
    with id_check.request() as req:
        t_id_start = env.now
        # Request one of the ID Checkpoint staff to check your id
        yield req

        # The ID Checkpoint staff is taking their time to make sure you are who you say you are.
        yield env.timeout(np.random.poisson(BETA_ID_CHECKPOINT))

        t_id = env.now - t_id_start
        # print('%s cleared the ID checkpoint in %.1f minutes.' % (name, t_id))

    # print('%s is ready to have their personal belongings checked %.1f' % (name, env.now))
    with personal_check.request() as req2:
        t_personal_start = env.now
        # Request one of the Personal Checkpoint staff to check your id
        yield req2

        # The Personal Checkpoint staff is taking their time to make sure you are only carrying things you are supposed to.
        yield env.timeout(np.random.uniform(LOW_PERSONAL_CHECKPOINT, HIGH_PERSONAL_CHECKPOINT))

        t_personal = env.now - t_personal_start
        # print('%s cleared the Personal checkpoint in %.1f minutes.' % (name, t_personal))

    t_security = env.now - t_security_start
    # print('Whoo! %s passed security after %.1f minutes.' % (name, t_security))
    print('%s took %.1f mins in ID Check, %.1f mins in Personal Check, for a toal of %.1f mins in security' % (name, t_id, t_personal, t_security))


def passenger_generator(env, id_check, personal_check):
    """Generate new passengers to go through the checkpoints"""
    for i in itertools.count():
        yield env.timeout(np.random.poisson(LAMBDA_ARRIVAL))
        env.process(passenger('Passenger %d' % i, env, id_check, personal_check))

# Setup and start the simulation
print('The airport is open!')
np.random.seed(RANDOM_SEED)

# Create environment and start processes
env = simpy.Environment()
id_check = simpy.Resource(env, ID_CHECKPOINT_STAFF)
personal_check = simpy.Resource(env, PERSONAL_CHECKPOINT_STAFF)
env.process(passenger_generator(env, id_check, personal_check))

# Execute!
env.run(until=SIM_TIME)
