---
marp: true
theme: gaia
paginate: true
math: mathjax
header: '![](assets/logo_cern.png) ![](assets/logo_infn.png) ![](assets/logo_unibo.png)'
---

<style>
/* pull slide titles to the top */
section {
  justify-content: flex-start !important;
  padding-top: 0.6rem !important;
  font-size: 28px;
  background: #ffffff !important;
  background-image: none !important;
  color: #1a1a2e;
}

h1, h2 {
  color: #1a237e;
}

h2 {
  margin-top: 0 !important;
  margin-bottom: 0.4em !important;
}

/* code blocks */
pre {
  background: #f0f4f8 !important;
  background-image: none !important;
  border: 1px solid #cdd5e0;
  border-radius: 6px;
}

pre code {
  background: #f0f4f8 !important;
  background-image: none !important;
  color: #1a1a2e !important;
}

code {
  background: #e8edf2 !important;
  background-image: none !important;
  color: #1a1a2e !important;
  border-radius: 3px;
}

/* highlighted / blockquote blocks */
blockquote {
  background: #fff8e1;
  border-left: 4px solid #f9a825;
  border-radius: 0 6px 6px 0;
  padding: 0.4em 0.8em;
  color: #4a3800;
}

/* Title slide */
section.title-slide {
  background: #0033A0 !important;
  background-image: none !important;
  color: white !important;
  justify-content: center !important;
  font-size: 42px !important;
}

section.title-slide h1 {
  color: white !important;
  font-size: 1.8em !important;
}

section.title-slide footer {
  position: absolute !important;
  bottom: 1rem !important;
  right: 1rem !important;
  left: auto !important;
  display: flex !important;
  gap: 1rem;
  align-items: center;
  background: transparent;
}

section.title-slide footer img {
  height: 1.8cm;
  width: auto;
  filter: brightness(0) invert(1);
}

/* header logos — top-right */
header {
  position: absolute;
  top: 0.5rem;
  right: 1rem;
  left: auto;
  display: flex;
  gap: 0.5rem;
  align-items: center;
  padding: 0;
  background: transparent;
}
header img {
  height: 0.8cm;
  width: auto;
}
</style>

<!-- _class: title-slide -->
<!-- _header: '' -->
<!-- _footer: '![](assets/logo_cern.png) ![](assets/logo_infn.png) ![](assets/logo_unibo.png)' -->
<!-- _paginate: false -->

# Introduction to GPU programming

**S. Balducci** · F. Pantaleo · A. Perego
UNIBO | INFN-CNAF | CERN

July 2026

---

## Content of the lectures
- Introduction to Parallel computing
- Heterogeneous Parallel computing systems
- CUDA Basics
- Parallel kernels
- Shared Memory and Synchronization
- Device Management
- Thrust library
- CUB library
- CuPy

---

## Content of the tutorial sessions

- Write and launch kernels
- Manage GPU memory
- Manage communication and synchronization
- From C++ standard algorithms to GPU execution using thrust

---

## Accelerators

- Exceptional raw power and memory bandwidth wrt CPUs
- Lower energy to solution
- Massively parallel architecture
- Low Memory/core

---

## Accelerators

- GPUs were traditionally used for real-time rendering/gaming. 
- AMD and NVIDIA main manufacturers for discrete GPUs, Intel for integrated ones

---

## CPU and GPU architecture compared

--- 

## **CPU** and GPU architecture compared

--- 

## CPU and **GPU** architecture compared

--- 

## Memory access: **cached**

---

## Memory access: **coalesced**

---

## Warps

---

## Heterogeneous Parallel Computing Systems

---

## Stencil kernel

```cpp
__global__ void stencil_1d(const int *in, int *out, int n) {
    __shared__ int temp[BLOCK_SIZE + 2 * RADIUS];
    auto g_index = threadIdx.x + blockIdx.x * blockDim.x;
    if (g_index < n) {
        auto s_index = threadIdx.x + RADIUS;

        // Read input elements into shared memory
        temp[s_index] = in[g_index];
        if (threadIdx.x < RADIUS) {
            temp[s_index - RADIUS] = g_index - RADIUS < 0 ? 0 : 
                                     in[g_index - RADIUS];
            temp[s_index + BLOCK_SIZE] = g_index + BLOCK_SIZE < n ? 
                                         in[g_index + BLOCK_SIZE] : 0;
        }

        // Apply the stencil
        int result = 0;
        for (int offset = -RADIUS ; offset <= RADIUS ; offset++)
            result += temp[s_index + offset];

        // Store the result
        out[g_index] = result;
    }
}
```
