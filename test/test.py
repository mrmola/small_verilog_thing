# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # Set the input values you want to test
    dut.ui_in.value = 20
    dut.uio_in.value = 30



    # Wait for one clock cycle to see the output values

    #TEST COUNTER
    for i in range(0,20):
        await ClockCycles(dut.clk, 1)
        dut._log.info(dut.counter.value)

    dut._log.info("Reset")
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 4)
    dut.rst_n.value = 1
    dut._log.info(dut.counter.value)
    assert dut.counter.value == 0
    await ClockCycles(dut.clk, 3)
    assert dut.counter.value == 2

    
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 4)
    dut.rst_n.value = 1
    dut.blink_offset.value = 100
    #TEST BLINKER
    #this is terrible but I don't know a better way that won't fail the test if you adjust blinker speed
    ones = 0
    zeros = 0
    difference = 0
    for i in range(0, 100000):
        await ClockCycles(dut.clk, 1)
        if(dut.blink_wire2.value != dut.blink_wire.value):
            difference += 1
        if(dut.blink_wire2.value == 0):
            zeros += 1
        else:
            ones += 1
    assert (abs(zeros-ones) < 1000)
    assert(difference/2 == 100)

    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
    # assert dut.uo_out.value == 50

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
