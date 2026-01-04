## SOT-MTJ
### System description

- It is a three terminal device 
- The free layer has perpendicular magnetization
- verilog-a code: EDA cluster -> /home/zhuzhf/code/project/MRAM2 -> **MRAM** library -> **SOT-zf** cell

### Resistor network

- The device structure and its corresponding resistor network is shown below.

![image-20260104120620194](README.assets/image-20260104120620194.png)

### Default Parameters

| Name                     | Value          | Name                     | Value             |
| ------------------------ | -------------- | ------------------------ | ----------------- |
| M~s~                     | 1000 emu/cm^3^ | R~p~                     | 2kΩ               |
| α                        | 0.01           | ρ~HM~                    | 200e-8 Ω.m        |
| H~k~                     | 1.5 T          | TMR                      | 150%              |
| FL polarization          | 0.4            | demag tensor             | online calculated |
| θ~SH~                    | −0.2           | θ~init~                  | 5°                |
| σ                        | (0,1,0)        | Temperature              | 0 K               |
| L~FL~, W~FL~, t~FL~ (nm) | 50, 50, 0.6    | L~HM~, W~HM~, t~HM~ (nm) | 55, 55, 4         |

### Determine the sign of **θ**~sh~

  - According to the following code, **σ** = +**y** when **J**<sub>c</sub> &gt; 0 along +**x** direction and **J**<sub>s</sub> along +**z** direction


```verilog
    parameter real PSOT_x     = 0;              //spin flux polarization
    parameter real PSOT_y     = 1;
    parameter real PSOT_z     = 0;
```

- Following $\mathbf{J}_\mathrm{s}=\theta_{sh}\mathbf{σ} \times \mathbf{J}_\mathrm{c}$, one can get that **θ**~sh~<0 
### Determine the switching direction

- As shown in the verification section, we apply **H**<sub>x</sub> = −**x**
- According to Δ**m**=**m**x(**m**x**σ**), one can get $\Delta{\mathbf{m}}=-\mathbf{y}$
- According to **L**=Δ**m**x**H**~x~, one can get **L** = −**z**, therefore, the magnetization is switched from up to down, which will be verified in the simulation.
  

### Verify SOT switching[^SOT-verification]

- By changing the following parameters, SOT switching identical to matlab simulation [^SOT-matlab] is obtained

  - ```verilog
    parameter real hext_x = -100e-3;
    ```
    
1. Virtuoso setups and results, where vdc is 44 mV
   
    ![image-20260104174249906](README.assets/image-20260104174249906.png)
    
    <img src="README.assets/image-20260104174151893.png" alt="image-20260104174151893" style="zoom:33%;" />
  - The waveform shows I<sub>HM</sub> = 88 μA, converting into current density is 4.0182e11 A/m^2^, which is used in the matlab simulation for benchmarking.
2. Comparison between matlab and verilog-a

<img src="README.assets/image-20250904180050650.png" alt="image-20250904180050650" style="zoom:33%;" />

### Basic SOT characteristics[^basic SOT]

**Sweeping Jc**

<img src="README.assets/image-20260102174750364.png" alt="image-20260102174750364" style="zoom:30%;" />

**Sweeping Hx**

## STT verification



## References

[^SOT]: OneDrive\code_softwares\ODE\LLG_integral\sample_updated\SOT_test

[^SOT-verification]: EDA cluster -> /home/zhuzhf/code/project/MRAM2 -> **MRAM** library -> **MTJzf_tb** cell
